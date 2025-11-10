// lib/screens/add_game_screen.dart

import 'package:flutter/material.dart';
import 'package:player_profiles/model/game.dart';
import 'package:player_profiles/model/game_schedule.dart';
import 'package:player_profiles/model/settings.dart';
import 'package:player_profiles/widgets/addgame_dialog.dart'; // We will create this
import 'package:player_profiles/widgets/input_field.dart';
import 'package:uuid/uuid.dart'; // Add uuid package: flutter pub add uuid

class AddGameScreen extends StatefulWidget {
  const AddGameScreen({super.key});

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
  // This will store the court schedules (e.g., Court 1, 6-9 PM)
  final List<GameSchedule> _schedules = [];

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
    // Show a dialog and wait for a new schedule to be returned
    final newSchedule = await showDialog<GameSchedule>(
      context: context,
      builder: (ctx) => const AddGameScheduleDialog(), // We'll create this dialog
    );

    if (newSchedule != null) {
      setState(() {
        _schedules.add(newSchedule);
      });
    }
  }

  void _saveGame() {
    // 1. Validate the form
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    
    // 2. Check if at least one schedule was added
    if (_schedules.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one schedule.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 3. Create the new Game object
    final newGame = Game(
      id: _uuid.v4(), // Generate a unique ID
      gameTitle: _gameTitleController.text,
      courtName: _courtNameController.text,
      courtRate: double.tryParse(_courtRateController.text) ?? 0.0,
      shuttlePrice: double.tryParse(_shuttlePriceController.text) ?? 0.0,
      divideCourtEqually: _divideEqually,
      schedules: _schedules, // Add the list of schedules
    );

    // 4. Return the new game to the GamesScreen
    Navigator.pop(context, newGame);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Game'),
        actions: [
          // Cancel Button
          TextButton(
            onPressed: () => Navigator.pop(context), // Just close the screen
            child: const Text('Cancel'),
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
                        // "Add Schedule" Button
                        IconButton.filled(
                          icon: const Icon(Icons.add),
                          onPressed: _openAddScheduleDialog,
                          style: IconButton.styleFrom(backgroundColor: Colors.blueAccent),
                        ),
                      ],
                    ),
                    
                    // --- List of Added Schedules ---
                    _schedules.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text('No schedules added yet. Tap (+) to add one.', style: TextStyle(color: Colors.grey)),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _schedules.length,
                            itemBuilder: (ctx, index) {
                              final schedule = _schedules[index];
                              return Card(
                                child: ListTile(
                                  leading: const Icon(Icons.timer),
                                  title: Text('Court ${schedule.courtNumber} (${schedule.timeRangeString})'),
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
                    const Divider(height: 32),
                    
                    // --- Details Section ---
                    Text(
                      'Game Details',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    // --- Court Name ---
                    InputField(
                      labelText: 'Court Name',
                      controller: _courtNameController,
                      prefixIcon: Icons.place,
                      validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    // --- Court Rate ---
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
                    // --- Shuttle Price ---
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
                    // --- Checkbox ---
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
                    const SizedBox(height: 32),
                    
                    // --- Save Button ---
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