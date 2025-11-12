import 'package:flutter/material.dart';
import 'package:player_profiles/model/game.dart';
import 'package:player_profiles/model/game_schedule.dart';
import 'package:player_profiles/screens/addplayer_togame_screen.dart';
import 'package:player_profiles/widgets/addgame_dialog.dart';
import 'package:player_profiles/widgets/input_field.dart';
import 'package:player_profiles/model/settings.dart';
import 'package:uuid/uuid.dart';
import 'package:player_profiles/model/player.dart';

class AddGameScreen extends StatefulWidget {
  final List<Player> allPlayers;

  const AddGameScreen({super.key, required this.allPlayers});

  @override
  State<AddGameScreen> createState() => _AddGameScreenState();
}

class _AddGameScreenState extends State<AddGameScreen> {
  final _formKey = GlobalKey<FormState>();
  final _settingsService = Settings();
  final _uuid = const Uuid();

  // --- Controllers ---
  final _gameTitleController = TextEditingController();
  final _courtNameController = TextEditingController();
  final _courtRateController = TextEditingController();
  final _shuttlePriceController = TextEditingController();
  
  // --- State ---
  bool _divideEqually = true;
  bool _isLoading = true;
  final List<GameSchedule> _schedules = [];
  List<Player> _selectedPlayers = [];

  void _navigateToAddPlayers() async {
    final newList = await Navigator.push<List<Player>>(
      context,
      MaterialPageRoute(
        builder: (context) => AddPlayerToGameScreen(
          allPlayers: widget.allPlayers,
          playersAlreadyInGame: _selectedPlayers,
        ),
      ),
    );

    if (newList != null) {
      setState(() {
        _selectedPlayers = newList;
      });
    }
  } 

  @override
  void initState() {
    super.initState();
    _loadDefaults();
  }

  @override
  void dispose() {
    _gameTitleController.dispose();
    _courtNameController.dispose();
    _courtRateController.dispose();
    _shuttlePriceController.dispose();
    super.dispose();
  }

  Future<void> _loadDefaults() async {
    final settings = await _settingsService.loadSettings();
    setState(() {
      _courtNameController.text = settings['courtName'];
      _courtRateController.text = settings['courtRate'].toString();
      _shuttlePriceController.text = settings['shuttlePrice'].toString();
      _divideEqually = settings['divideEqually'];
      _isLoading = false;
    });
  }

  void _openAddScheduleDialog() async {
    final newSchedule = await showDialog<GameSchedule>(
      context: context,
      builder: (ctx) => const AddGameScheduleDialog(),
    );

    if (newSchedule != null) {
      setState(() {
        _schedules.add(newSchedule);
      });
    }
  }

  void _saveGame() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    
    if (_schedules.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one schedule.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newGame = Game(
      id: _uuid.v4(),
      gameTitle: _gameTitleController.text,
      courtName: _courtNameController.text,
      courtRate: double.tryParse(_courtRateController.text) ?? 0.0,
      shuttlePrice: double.tryParse(_shuttlePriceController.text) ?? 0.0,
      divideCourtEqually: _divideEqually,
      schedules: _schedules,
      players: _selectedPlayers,
      shuttlesUsed: 0,
    );
    
    Navigator.pop(context, newGame);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(251, 251, 251, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text('Add New Game',
        style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colors.blueAccent,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
              style: TextStyle(color: Colors.blueAccent, fontSize: 16),
            ),
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Game Title ---
                    InputField(
                      labelText: 'Game Title (Optional)',
                      hintText: 'e.g., "Weekday Grind". Defaults to date.',
                      controller: _gameTitleController,
                      prefixIcon: Icons.edit,
                    ),
                    const SizedBox(height: 24),
                    
                    // --- Schedule Section ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Schedules & Courts',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        IconButton.filled(
                          icon: const Icon(Icons.add),
                          onPressed: _openAddScheduleDialog,
                          style: IconButton.styleFrom(backgroundColor: Colors.blueAccent),
                        ),
                      ],
                    ),
                    
                    _schedules.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text('No schedules added yet.', style: TextStyle(color: Colors.grey)),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _schedules.length,
                            itemBuilder: (ctx, index) {
                              final schedule = _schedules[index];
                              return Card(
                                color: Colors.white,
                                child: ListTile(
                                  leading: const Icon(Icons.timer),
                                  title: Text('${schedule.courtNumber} (${schedule.timeRangeString})'),
                                  subtitle: Text(schedule.dateString),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _schedules.removeAt(index);
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                    const Divider(height: 32, color: Color.fromARGB(255, 187, 187, 187)),

                    // --- Players Section ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Players (${_selectedPlayers.length})',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        IconButton.filled(
                          icon: const Icon(Icons.add),
                          onPressed: _navigateToAddPlayers,
                          style: IconButton.styleFrom(backgroundColor: Colors.blueAccent),
                        ),
                      ],
                    ),
                    _selectedPlayers.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text('No players added yet.', style: TextStyle(color: Colors.grey)),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _selectedPlayers.length,
                            itemBuilder: (ctx, index) {
                              final player = _selectedPlayers[index];
                              return Card(
                                color: Colors.white,
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blueAccent,
                                    child: Text(
                                      player.nickname.isNotEmpty ? player.nickname[0].toUpperCase() : '?',
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  title: Text(player.nickname),
                                  subtitle: Text(player.name),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _selectedPlayers.removeAt(index);
                                      });
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                    const Divider(height: 32, color: Color.fromARGB(255, 187, 187, 187)),

                    // --- Details Section ---
                    Text(
                      'Game Details',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      labelText: 'Court Name',
                      controller: _courtNameController,
                      prefixIcon: Icons.place,
                      validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      labelText: 'Court Rate (per hour)',
                      controller: _courtRateController,
                      prefixIcon: Icons.monetization_on,
                      isNumber: true,
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Required';
                        if (double.tryParse(val) == null) return 'Invalid number';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      labelText: 'Shuttlecock Price',
                      controller: _shuttlePriceController,
                      prefixIcon: Icons.price_change,
                      isNumber: true,
                      keyboardType: TextInputType.number,
                      validator: (val) {
                         if (val == null || val.isEmpty) return 'Required';
                        if (double.tryParse(val) == null) return 'Invalid number';
                        return null;
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        CheckboxListTile(
                          title: const Text('Divide court equally among players'),
                          value: _divideEqually,
                          onChanged: (newValue) {
                            setState(() {
                              _divideEqually = newValue ?? true;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          activeColor: Colors.blueAccent,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          // child: Text(
                          //   'If unchecked, court cost will not be divided among players by default.',
                          //   style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                          // ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    ElevatedButton(
                      onPressed: _saveGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Save Game',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}