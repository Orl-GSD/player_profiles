import 'package:flutter/material.dart';
import 'package:player_profiles/model/player.dart';
import 'package:player_profiles/screens/addplayer_screen.dart';
import 'package:player_profiles/widgets/player_card.dart';
import 'package:player_profiles/data/players_list.dart';

class PlayerProfilesScreen extends StatefulWidget {
  const PlayerProfilesScreen({super.key});

  @override
  State<PlayerProfilesScreen> createState() => _PlayerProfilesScreenState();
}

class _PlayerProfilesScreenState extends State<PlayerProfilesScreen> {
  List<Player> filteredPlayers = [];
  final TextEditingController _searchController = TextEditingController();

  final List<Player> _players = players;

  @override
  void initState() {
    super.initState();
    filteredPlayers = List.from(_players);
  }

  // Search Player Function
  void _searchPlayer(String query) {
    final filtered = _players.where((player) {
      final nameLower = player.name.toLowerCase();
      final nicknameLower = player.nickname.toLowerCase();
      final searchLower = query.toLowerCase();

      return nameLower.contains(searchLower) || nicknameLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredPlayers = filtered;
    });
  }

  // Add Player Function
  void _navigateToAddPlayer() async {
    final newPlayer = await Navigator.push<Player>(
      context,
      MaterialPageRoute(builder: (context) => const AddPlayerScreen()),
    );

    if (newPlayer != null) {
      setState(() {
        _players.add(newPlayer);
        filteredPlayers = List.from(_players);
      });
    }
  }

  // Update Player Function
  void _updatePlayer(Player updatedPlayer) {
    setState(() {
      // Try multiple identifiers since we don't have ID
      final index = _players.indexWhere((p) => 
          p.name == updatedPlayer.name && 
          p.contactNum == updatedPlayer.contactNum
      );
      
      if (index != -1) {
        _players[index] = updatedPlayer;
        filteredPlayers = List.from(_players);
        print('Player updated successfully!');
      } else {
        print('Player not found!');
      }
    });
  }

  // Delete Player Function
  void _deletePlayer(Player deletedPlayer) {
    setState(() {
      _players.removeWhere((p) => p.id == deletedPlayer.id); // Use ID instead of nickname
      filteredPlayers = List.from(_players);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      // --- MODIFIED BODY ---
      body: Column( // 1. Removed the 'SafeArea(top: false, ...)' wrapper
        children: [
          Container(
            width: double.infinity,
            // 2. Removed vertical padding, kept horizontal
            padding: const EdgeInsets.symmetric(horizontal: 20), 
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Color.fromARGB(255, 196, 196, 196),
                  width: 1,
                ),
              ),
            ),
            // 3. Add a new SafeArea here to wrap the header's content
            child: SafeArea( 
              bottom: false, // We only want the top padding
              // 4. Add your vertical padding back INSIDE the SafeArea
              child: Padding( 
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    // Top Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'All Players',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.blueAccent,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        
                        // Add Player Button
                        TextButton.icon(
                          onPressed: _navigateToAddPlayer,
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text(
                            'Add Player',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Search Bar
                    Focus(
                      onFocusChange: (hasFocus) {},
                      child: Builder(
                        builder: (context) {
                          final hasFocus = Focus.of(context).hasFocus;
                          return TextField(
                            controller: _searchController,
                            onChanged: _searchPlayer,
                            cursorColor: Colors.blueAccent,
                            decoration: InputDecoration(
                              hintText: 'Search by name or nickname',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 202, 202, 202),
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.blueAccent,
                                  width: 2,
                                )
                              ),
                              filled: true,
                              fillColor: const Color.fromARGB(255, 251, 253, 255),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 0,
                              ),
                            ),
                          );
                        }
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Search bar filters players and updates UI
          Expanded(
            child: filteredPlayers.isEmpty
                ? const Center(
                    child: Text(
                      'No players found.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredPlayers.length,
                    itemBuilder: (context, index) {
                      final player = filteredPlayers[index];
                      return PlayerCard(
                        player: player,
                        onPlayerUpdated: _updatePlayer,
                        onPlayerDeleted: _deletePlayer,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
