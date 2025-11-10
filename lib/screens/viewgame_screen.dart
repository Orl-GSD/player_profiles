// lib/screens/view_game_screen.dart

import 'package:flutter/material.dart';
import 'package:player_profiles/model/game.dart';
import 'package:intl/intl.dart';

class ViewGameScreen extends StatelessWidget {
  final Game game;

  const ViewGameScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return Scaffold(
      appBar: AppBar(
        title: Text(game.displayName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Schedules Section ---
            _buildSectionTitle(context, 'Schedules & Courts'),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: game.schedules.length,
              itemBuilder: (context, index) {
                final schedule = game.schedules[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.calendar_today, color: Colors.blueAccent),
                    title: Text('Court ${schedule.courtNumber}'),
                    subtitle: Text('${schedule.dateString}  (${schedule.timeRangeString})'),
                  ),
                );
              },
            ),
            const Divider(height: 32),

            // --- Game Details Section ---
            _buildSectionTitle(context, 'Game Details'),
            _buildDetailRow(
              icon: Icons.place_outlined,
              title: 'Court Name',
              value: game.courtName,
            ),
            _buildDetailRow(
              icon: Icons.monetization_on_outlined,
              title: 'Court Rate',
              value: '${currencyFormat.format(game.courtRate)} / hour',
            ),
            _buildDetailRow(
              icon: Icons.price_change_outlined,
              title: 'Shuttle Price',
              value: '${currencyFormat.format(game.shuttlePrice)} / piece',
            ),
            _buildDetailRow(
              icon: Icons.pie_chart_outline,
              title: 'Cost Division',
              value: game.divideCourtEqually
                  ? 'Divide court equally'
                  : 'Pay-per-game (not divided)',
            ),
            const Divider(height: 32),

    // --- Players Section ---
                // _buildSectionTitle(context, 'Players (${game.playerCount})'),
                // if (game.players.isEmpty)
                //   const Center(
                //     child: Padding(
                //       padding: EdgeInsets.all(16.0),
                //       child: Text(
                //         'No players have been added to this game yet.',
                //         style: TextStyle(color: Colors.grey),
                //       ),
                //     ),
                //   )
                // else
                //   ListView.builder(
                //     shrinkWrap: true,
                //     physics: const NeverScrollableScrollPhysics(),
                //     itemCount: game.players.length,
                //     itemBuilder: (context, index) {
                //       final player = game.players[index];
                //       return Card(
                //         margin: const EdgeInsets.only(bottom: 8),
                //         child: ListTile(
                //           leading: CircleAvatar(
                //             backgroundColor: Colors.blueAccent,
                //             child: Text(
                //               player.nickname.isNotEmpty ? player.nickname[0].toUpperCase() : '?',
                //               style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                //             ),
                //           ),
                //           title: Text(player.nickname),
                //           subtitle: Text(player.name),
                //         ),
                //       );
                //     },
                //   ),
          ],
        ),
      ),
    );
  }

  // Helper widget for section titles
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  // Helper widget for detail rows
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