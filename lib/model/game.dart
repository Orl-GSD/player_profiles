// lib/model/game.dart

import 'package:player_profiles/model/game_schedule.dart';
import 'package:player_profiles/model/player.dart';

class Game {
  final String id;
  String? gameTitle;
  String courtName;
  List<GameSchedule> schedules;
  double courtRate;
  double shuttlePrice;
  bool divideCourtEqually;
  int shuttlesUsed;
  List<Player> players; 

  Game({
    required this.id,
    this.gameTitle,
    required this.courtName,
    required this.schedules,
    required this.courtRate,
    required this.shuttlePrice,
    required this.divideCourtEqually,
    this.shuttlesUsed = 0,
   List<Player>? players,
  }) : players = players ?? [];

  String get displayName {
    if (gameTitle != null && gameTitle!.isNotEmpty) {
      return gameTitle!;
    }
    if (schedules.isNotEmpty) {
      return 'Game on ${schedules.first.dateString}';
    }
    return 'Untitled Game';
  }

  int get playerCount => players.length;

  double get totalCost {
    double courtCost = 0;
    for (var schedule in schedules) {
      final duration = schedule.endTime.difference(schedule.startTime);
      courtCost += (duration.inMinutes / 60.0) * courtRate;
    }

    double shuttleCost = shuttlesUsed * shuttlePrice;
    
    return courtCost + shuttleCost;
  }
}