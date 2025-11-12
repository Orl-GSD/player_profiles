import 'package:player_profiles/model/game.dart';
import 'package:player_profiles/model/game_schedule.dart';
import 'package:player_profiles/data/players_list.dart';

final DateTime today = DateTime.now();
final DateTime nextWeek = today.add(const Duration(days: 7));

// Schedules for Game 1 (Today)
final game1_schedule1 = GameSchedule(
  id: 'g1s1',
  courtNumber: '1',
  gameDate: today,
  startTime: DateTime(today.year, today.month, today.day, 18, 0), // 6:00 PM
  endTime: DateTime(today.year, today.month, today.day, 21, 0), // 9:00 PM
);

final game1_schedule2 = GameSchedule(
  id: 'g1s2',
  courtNumber: '2',
  gameDate: today,
  startTime: DateTime(today.year, today.month, today.day, 19, 0), // 7:00 PM
  endTime: DateTime(today.year, today.month, today.day, 21, 0), // 9:00 PM
);

// Schedules for Game 2 (Next Week)
final game2_schedule1 = GameSchedule(
  id: 'g2s1',
  courtNumber: 'Main Court',
  gameDate: nextWeek,
  startTime: DateTime(nextWeek.year, nextWeek.month, nextWeek.day, 10, 0), // 10:00 AM
  endTime: DateTime(nextWeek.year, nextWeek.month, nextWeek.day, 13, 0), // 1:00 PM
);

// --- Main Games List ---

final List<Game> games = [
  Game(
    id: 'g1',
    gameTitle: 'Weekday Warriors',
    courtName: 'PowerSmash Badminton Center',
    courtRate: 150.0,
    shuttlePrice: 50.0,
    divideCourtEqually: true,
    schedules: [game1_schedule1, game1_schedule2],
    players: players.sublist(0, 3), 
    shuttlesUsed: 3,
  ),
  Game(
    id: 'g2',
    gameTitle: 'Weekend Open Play',
    courtName: 'Rizal Badminton Hall',
    courtRate: 200.0,
    shuttlePrice: 55.0,
    divideCourtEqually: true,
    schedules: [game2_schedule1],
    players: players, 
    shuttlesUsed: 5,
  ),
  Game(
    id: 'g3',
    courtName: 'PowerSmash Badminton Center',
    courtRate: 150.0,
    shuttlePrice: 50.0,
    divideCourtEqually: false,
    schedules: [
      GameSchedule(
        id: 'g3s1',
        courtNumber: '3',
        gameDate: today.add(const Duration(days: 2)),
        startTime: DateTime(today.year, today.month, today.day + 2, 19, 0),
        endTime: DateTime(today.year, today.month, today.day + 2, 22, 0),
      ),
    ],
    players: [],
    shuttlesUsed: 0,
  ),
];