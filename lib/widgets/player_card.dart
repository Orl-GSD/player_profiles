import 'package:flutter/material.dart';
import 'package:player_profiles/model/player.dart';
import 'package:player_profiles/screens/updateplayer_screen.dart';
import 'package:player_profiles/widgets/delete_confirmation_modal.dart';

class PlayerCard extends StatelessWidget {
  final Player player;
  final Function(Player)? onPlayerDeleted;
  final Function(Player)? onPlayerUpdated;

  const PlayerCard({super.key, required this.player, this.onPlayerUpdated, this.onPlayerDeleted});

  @override
  Widget build(BuildContext context) {
    
    // Dismissible Card to Add Swipe Action/s
    return Dismissible(
      key: Key(player.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(top: 16, right: 16, left: 16),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 20),
            child: Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 28,
                ),
                Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      
      // Delete Confirmation Dialog After Swiping
      confirmDismiss: (direction) async {
        final confirmDelete = await showDialog<bool>(
          context: context,
          builder: (context) => DeleteConfirmationModal(
            playerName: player.name,
            onConfirm: () => Navigator.pop(context, true),
            onCancel: () => Navigator.pop(context, false),
          ),
        );
        return confirmDelete ?? false;
      },
      onDismissed: (direction) {
        if (onPlayerDeleted != null) {
          onPlayerDeleted!(player);
          
          // Delete Success Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.white
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Player deleted!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ]
              ), 
              backgroundColor: Color.fromARGB(255, 218, 60, 60),
            ),
          );
        }
      },
      child: GestureDetector(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdatePlayerScreen(player: player),
            ),
          );

          if (result == 'delete' && onPlayerDeleted != null) {
            onPlayerDeleted!(player);
          } else if (result is Player && onPlayerUpdated != null) {
            onPlayerUpdated!(result);
          }
        },
        child: Container(
          margin: const EdgeInsets.only(top: 16, right: 16, left: 16),
          height: 100,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
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
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color.fromARGB(255, 9, 144, 255),
                child: Text(
                  player.name.isNotEmpty ? player.name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Player Information
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.nickname,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${player.name} | ${player.levelStartString} - ${player.levelEndString}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}