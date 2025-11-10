// lib/model/game_schedule.dart

import 'package:intl/intl.dart';

class GameSchedule {
  String id;
  String courtNumber; // e.g., "1" or "Main Court"
  DateTime startTime;
  DateTime endTime;
  DateTime gameDate;

  GameSchedule({
    required this.id,
    required this.courtNumber,
    required this.startTime,
    required this.endTime,
    required this.gameDate,
  });

  // Helper to format the time range
  String get timeRangeString {
    final format = DateFormat.jm(); // e.g., 6:00 PM
    return '${format.format(startTime)} - ${format.format(endTime)}';
  }

  // Helper to format the date
  String get dateString {
    final format = DateFormat.yMMMd(); // e.g., Nov 10, 2025
    return format.format(gameDate);
  }
}