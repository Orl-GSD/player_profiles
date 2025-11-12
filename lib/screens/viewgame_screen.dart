import 'package:flutter/material.dart';
import 'package:player_profiles/model/game.dart';
import 'package:player_profiles/model/player.dart';
import 'package:player_profiles/screens/addplayer_togame_screen.dart';
import 'package:intl/intl.dart';

class ViewGameScreen extends StatefulWidget {
  final Game game;
  final List<Player> allPlayers; 

  const ViewGameScreen({
    super.key,
    required this.game,
    required this.allPlayers,
  });

  @override
  State<ViewGameScreen> createState() => _ViewGameScreenState();
}

class _ViewGameScreenState extends State<ViewGameScreen> {
  late final NumberFormat currencyFormat;

  @override
  void initState() {
    super.initState();
    // Use en_PH and ₱ symbol
    currencyFormat = NumberFormat.currency(locale: 'en_PH', symbol: '₱');
  }

  void _updateShuttles(int change) {
    if (widget.game.shuttlesUsed + change < 0) {
      return;
    }
    setState(() {
      widget.game.shuttlesUsed += change;
    });
  }

  void _navigateToAddPlayers() async {
    final newList = await Navigator.push<List<Player>>(
      context,
      MaterialPageRoute(
        builder: (context) => AddPlayerToGameScreen(
          allPlayers: widget.allPlayers,
          playersAlreadyInGame: widget.game.players,
        ),
      ),
    );

    if (newList != null) {
      setState(() {
        widget.game.players = newList;
      });
    }
  }

  String _calculateCostPerPlayer() {
    if (!widget.game.divideCourtEqually) {
      return 'N/A (Not Divided)';
    }
    if (widget.game.playerCount == 0) {
      return 'N/A (0 Players)';
    }
    
    final double costPerPlayer = widget.game.totalCost / widget.game.playerCount;
    return currencyFormat.format(costPerPlayer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.game.displayName),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Pop with 'true'
            child: const Text('Done', style: TextStyle(color: Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, true); // Also pop with 'true'
          return true;
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Schedules Section ---
              _buildSectionTitle(context, 'Schedules & Courts'),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.game.schedules.length,
                itemBuilder: (context, index) {
                  final schedule = widget.game.schedules[index];
                  return Card(
                    color: const Color.fromRGBO(250, 250, 250, 1),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today, color: Colors.blueAccent),
                      title: Text('Court ${schedule.courtNumber}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                      subtitle: Text('${schedule.dateString}  (${schedule.timeRangeString})'),
                    ),
                  );
                },
              ),
              const Divider(height: 32, color: Color.fromARGB(255, 187, 187, 187)),

              // --- Game Details Section ---
              _buildSectionTitle(context, 'Game Details'),
              _buildDetailRow(
                icon: Icons.place_outlined,
                title: 'Court Name',
                value: widget.game.courtName,
              ),
              _buildDetailRow(
                icon: Icons.monetization_on_outlined,
                title: 'Court Rate',
                value: '${currencyFormat.format(widget.game.courtRate)}/hr',
              ),
              _buildShuttleCounter(),
              _buildDetailRow(
                icon: Icons.pie_chart_outline,
                title: 'Court Division',
                value: widget.game.divideCourtEqually
                    ? 'Divide court equally'
                    : 'Not divided',
              ),
              const Divider(height: 32, color: Color.fromARGB(255, 187, 187, 187)),

              // --- Total Cost Section ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    'Total Cost',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    currencyFormat.format(widget.game.totalCost),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                  ),
                ],
              ),
              const Divider(height: 32, color: Color.fromARGB(255, 187, 187, 187)),

              // // --- Cost Breakdown Section ---
              // if (widget.game.divideCourtEqually) ...[
              //   _buildSectionTitle(context, 'Cost Breakdown'),
              //   _buildDetailRow(
              //     icon: Icons.check_circle_outline,
              //     title: 'Division Setting',
              //     value: widget.game.divideCourtEqually
              //         ? 'Divide cost equally'
              //         : 'Not divided',
              //   ),
              //   _buildDetailRow(
              //     icon: Icons.people_outline,
              //     title: 'Player Count',
              //     value: '${widget.game.playerCount} players',
              //   ),
              //   Padding(
              //     padding: const EdgeInsets.symmetric(vertical: 8.0),
              //     child: Row(
              //       children: [
              //         Icon(Icons.person_pin_circle_outlined, color: Colors.grey[600]),
              //         const SizedBox(width: 16),
              //         Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             const Text(
              //               'Cost Per Player',
              //               style: TextStyle(color: Colors.grey, fontSize: 12),
              //             ),
              //             Text(
              //               _calculateCostPerPlayer(),
              //               style: const TextStyle(
              //                 fontSize: 16, 
              //                 fontWeight: FontWeight.bold,
              //                 color: Colors.green
              //               ),
              //             ),
              //           ],
              //         )
              //       ],
              //     ),
              //   ),
              //   const Divider(height: 32, color: Color.fromARGB(255, 187, 187, 187)),
              // ],
              
              // --- Players Section ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle(context, 'Players (${widget.game.playerCount})'),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.blueAccent),
                    onPressed: _navigateToAddPlayers,
                  ),
                ],
              ),
              if (widget.game.players.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'No players have been added to this game yet.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.game.players.length,
                  itemBuilder: (context, index) {
                    final player = widget.game.players[index];
                    return Card(
                      color: const Color.fromRGBO(250, 250, 250, 1),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Text(
                            player.nickname.isNotEmpty ? player.nickname[0].toUpperCase() : '?',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(player.nickname, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(player.name),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildShuttleCounter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.price_change_outlined, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Shuttlecocks Used',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                '${widget.game.shuttlesUsed} pieces (${currencyFormat.format(widget.game.shuttlePrice)}/pc)',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () => _updateShuttles(-1),
            icon: const Icon(Icons.remove_circle_outline),
          ),
          IconButton(
            onPressed: () => _updateShuttles(1),
            icon: const Icon(Icons.add_circle, color: Colors.blueAccent),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDetailRow({required IconData icon, required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          )
        ],
      ),
    );
  }
}