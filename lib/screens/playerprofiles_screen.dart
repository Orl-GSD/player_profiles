import 'package:flutter/material.dart';
import 'package:player_profiles/model/player.dart';
import 'package:player_profiles/screens/addplayer_screen.dart';
import 'package:player_profiles/widgets/player_card.dart';
// import 'package:player_profiles/data/players_list.dart'; // No longer needed here

class PlayerProfilesScreen extends StatefulWidget {
  // 1. Receives the master list
  final List<Player> allPlayers;

  const PlayerProfilesScreen({
    super.key,
    required this.allPlayers, // 2. Added to constructor
  });

  @override
  State<PlayerProfilesScreen> createState() => _PlayerProfilesScreenState();
}

class _PlayerProfilesScreenState extends State<PlayerProfilesScreen> {
  List<Player> filteredPlayers = [];
  final TextEditingController _searchController = TextEditingController();

  // 3. The local list is GONE

  @override
  void initState() {
    super.initState();
    // 4. Initialize filter from the WIDGET's list
    filteredPlayers = List.from(widget.allPlayers);
  }

  // 5. All functions now reference 'widget.allPlayers'
  void _searchPlayer(String query) {
    final filtered = widget.allPlayers.where((player) {
      final nameLower = player.name.toLowerCase();
      final nicknameLower = player.nickname.toLowerCase();
      final searchLower = query.toLowerCase();

      return nameLower.contains(searchLower) || nicknameLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredPlayers = filtered;
    });
  }

  void _navigateToAddPlayer() async {
    final newPlayer = await Navigator.push<Player>(
      context,
      MaterialPageRoute(builder: (context) => const AddPlayerScreen()),
    );

    if (newPlayer != null) {
      setState(() {
        widget.allPlayers.add(newPlayer); // Add to the master list
        filteredPlayers = List.from(widget.allPlayers);
      });
    }
  }

  void _updatePlayer(Player updatedPlayer) {
    setState(() {
      final index = widget.allPlayers.indexWhere((p) => p.id == updatedPlayer.id);
      
      if (index != -1) {
        widget.allPlayers[index] = updatedPlayer;
        filteredPlayers = List.from(widget.allPlayers);
        print('Player updated successfully!');
      } else {
        print('Player not found!');
      }
    });
  }

  void _deletePlayer(Player deletedPlayer) {
    setState(() {
      widget.allPlayers.removeWhere((p) => p.id == deletedPlayer.id);
      filteredPlayers = List.from(widget.allPlayers);
    });
  }

  @override
  Widget build(BuildContext context) {
    // This is the build method with the corrected header
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      body: Column(
        children: [
          Container(
            width: double.infinity,
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
            child: SafeArea(
              bottom: false,
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
                    TextField(
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
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Player List
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