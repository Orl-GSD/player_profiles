import 'package:flutter/material.dart';
import 'package:player_profiles/screens/playerprofiles_screen.dart';
import 'package:player_profiles/widgets/navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NavBar(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: const ColorScheme.light(
          primary: Colors.blueAccent,
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: Color.fromARGB(255, 35, 35, 35),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blueAccent,
          ),
        ),
      )
    );
  }
}


