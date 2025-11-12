import 'package:flutter/material.dart';
import 'package:player_profiles/model/game.dart';
import 'package:player_profiles/screens/addgame_screen.dart';
import 'package:player_profiles/widgets/game_card.dart';
import 'package:player_profiles/screens/viewgame_screen.dart';
import 'package:player_profiles/model/player.dart';


class GamesScreen extends StatefulWidget {
  final List<Player> allPlayers;
  final List<Game> allGames; 

  const GamesScreen({
    super.key,
    required this.allPlayers,
    required this.allGames,
  });

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  List<Game> _filteredGames = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredGames = List.from(widget.allGames);
  }

  void _searchGame(String query) {
    final filtered = widget.allGames.where((game) {
      final titleLower = game.displayName.toLowerCase();
      final dateLower = game.schedules.isNotEmpty
          ? game.schedules.first.dateString.toLowerCase()
          : '';
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower) || dateLower.contains(searchLower);
    }).toList();

    setState(() {
      _filteredGames = filtered;
    });
  }

  void _navigateToAddGame() async {
    final newGame = await Navigator.push<Game>(
      context,
      MaterialPageRoute(
        builder: (context) => AddGameScreen(allPlayers: widget.allPlayers),
      ),
    );

    if (newGame != null) {
      setState(() {
        widget.allGames.add(newGame);
        _searchController.clear();
        _filteredGames = List.from(widget.allGames);
      });
    }
  }

  void _deleteGame(Game game) {
    setState(() {
      widget.allGames.removeWhere((g) => g.id == game.id);
      _filteredGames.removeWhere((g) => g.id == game.id);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Game deleted successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'All Games',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.blueAccent,
                          ),
                        ),
                        
                        TextButton.icon(
                          onPressed: _navigateToAddGame,
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text(
                            'Add Game',
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
                    
                    TextField(
                      controller: _searchController,
                      onChanged: _searchGame,
                      cursorColor: Colors.blueAccent,
                      decoration: InputDecoration(
                        hintText: 'Search by name or date',
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
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          Expanded(
            child: _filteredGames.isEmpty
                ? const Center(
                    child: Text(
                      'No games found. Tap "Add Game" to create one.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredGames.length,
                    itemBuilder: (context, index) {
                      final game = _filteredGames[index];
                      return GameCard(
                        game: game,
                        onDelete: _deleteGame,
                        onTap: () async {
                          final bool? needsRefresh = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewGameScreen(
                                game: game,
                                allPlayers: widget.allPlayers, 
                              ),
                            ),
                          );
                          
                          if (needsRefresh == true) {
                            setState(() {});
                          }
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