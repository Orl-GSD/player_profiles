// lib/screens/add_player_to_game_screen.dart

import 'package:flutter/material.dart';
import 'package:player_profiles/model/player.dart';

class AddPlayerToGameScreen extends StatefulWidget {
  final List<Player> allPlayers;
  final List<Player> playersAlreadyInGame;

  const AddPlayerToGameScreen({
    super.key,
    required this.allPlayers,
    required this.playersAlreadyInGame,
  });

  @override
  State<AddPlayerToGameScreen> createState() => _AddPlayerToGameScreenState();
}

class _AddPlayerToGameScreenState extends State<AddPlayerToGameScreen> {
  // This will hold the players we are selecting
  late List<Player> _selectedPlayers;
  List<Player> _filteredPlayers = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Make a *copy* of the list we're passed
    _selectedPlayers = List.from(widget.playersAlreadyInGame);
    _filteredPlayers = List.from(widget.allPlayers);
  }

  void _searchPlayer(String query) {
    final filtered = widget.allPlayers.where((player) {
      final nameLower = player.name.toLowerCase();
      final nicknameLower = player.nickname.toLowerCase();
      final searchLower = query.toLowerCase();
      return nameLower.contains(searchLower) || nicknameLower.contains(searchLower);
    }).toList();
    setState(() {
      _filteredPlayers = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Players to Game'),
        actions: [
          // "Done" button returns the new list
          TextButton(
            onPressed: () {
              Navigator.pop(context, _selectedPlayers);
            },
            child: const Text('Done', style: TextStyle(color: Colors.blueAccent, fontSize: 16)),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _searchPlayer,
              decoration: InputDecoration(
                hintText: 'Search for a player...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredPlayers.length,
              itemBuilder: (context, index) {
                final player = _filteredPlayers[index];
                // Check if this player is in our selected list
                final bool isSelected = _selectedPlayers.any((p) => p.id == player.id);

                return CheckboxListTile(
                  title: Text(player.nickname),
                  subtitle: Text(player.name),
                  value: isSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        // Add player if they're not already in
                        if (!isSelected) {
                          _selectedPlayers.add(player);
                        }
                      } else {
                        // Remove player
                        _selectedPlayers.removeWhere((p) => p.id == player.id);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}