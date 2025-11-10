// lib/widgets/game_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:player_profiles/model/game.dart';

class GameCard extends StatelessWidget {
  final Game game;
  final VoidCallback onTap;
  final Function(Game) onDelete;

  const GameCard({
    super.key,
    required this.game,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Formatter for currency
    final currencyFormat = NumberFormat.currency(locale: 'en_PH', symbol: '₱');
    
    return Dismissible(
      key: Key(game.id), // Unique key for each game
      direction: DismissDirection.endToStart,
      
      // --- Swipe-to-delete confirmation ---
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Game?'),
            content: Text('Are you sure you want to delete "${game.displayName}"? This action cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false), // Don't delete
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true), // Yes, delete
                child: const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      
      // --- What happens after confirmation ---
      onDismissed: (direction) {
        onDelete(game);
      },
      
      // --- The red background behind the card ---
      background: Container(
        color: Colors.redAccent,
        margin: const EdgeInsets.only(top: 16, right: 16, left: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            SizedBox(width: 8),
            Icon(Icons.delete, color: Colors.white),
          ],
        ),
      ),
      
      // --- The Card itself ---
      child: GestureDetector(
        onTap: onTap, // For opening "View Game" screen later
        child: Container(
          margin: const EdgeInsets.only(top: 16, right: 16, left: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                game.displayName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [  
                  // --- Info Chip: Total Cost ---
                  InfoChip(
                    icon: Icons.monetization_on_outlined,
                    text: currencyFormat.format(game.totalCost),
                  ),
                ],
              ),
              
              // --- Show schedule info if it exists ---
              if (game.schedules.isNotEmpty) ...[
                const Divider(height: 20),
                InfoChip(
                  icon: Icons.calendar_today_outlined,
                  text: '${game.schedules.first.dateString} (${game.schedules.first.timeRangeString})',
                ),
                if (game.schedules.length > 1)
                  Padding(
                    padding: const EdgeInsets.only(left: 22, top: 4),
                    child: Text(
                      '+ ${game.schedules.length - 1} more...',
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

// A small helper widget for the chips in the card
class InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const InfoChip({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.black54),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
      ],
    );
  }
}