// lib/main_navigation_screen.dart

import 'package:flutter/material.dart';
import 'package:player_profiles/screens/games_screen.dart';
import 'package:player_profiles/screens/playerprofiles_screen.dart';
import 'package:player_profiles/screens/usersettings_screen.dart';
import 'package:player_profiles/data/players_list.dart';
import 'package:player_profiles/data/games_list.dart';
import 'package:player_profiles/model/player.dart';
import 'package:player_profiles/model/game.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBar();
}

class _NavBar extends State<NavBar> {
  // Holds the current selected tab index
  int _selectedIndex = 0;

  final List<Player> _allPlayers = List.from(players);
  final List<Game> _allGames = List.from(games);

  // The list of screens that correspond to the tabs
  List<Widget> get _screens => <Widget>[
    PlayerProfilesScreen(allPlayers: _allPlayers),
    GamesScreen(allGames: _allGames, allPlayers: _allPlayers),
    const UserSettingsScreen(),
  ];

  // This function is called when a tab is tapped
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body is set to the currently selected screen
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      
      // This is the bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Players',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_tennis),
            label: 'Games',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,    // Highlights the current tab
        selectedItemColor: Colors.blueAccent, // Color for the active tab
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey[600],           // Calls our function on tap
      ),
    );
  }
}