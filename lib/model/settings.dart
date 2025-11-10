import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  static const String _courtNameKey = 'defaultCourtName';
  static const String _courtRateKey = 'defaultCourtRate';
  static const String _shuttlePriceKey = 'defaultShuttlePrice';
  static const String _divideEquallyKey = 'defaultDivideEqually';

  Future<void> saveSettings({
    required String courtName,
    required double courtRate,
    required double shuttlePrice,
    required bool divideEqually,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_courtNameKey, courtName);
    await prefs.setDouble(_courtRateKey, courtRate);
    await prefs.setDouble(_shuttlePriceKey, shuttlePrice);
    await prefs.setBool(_divideEquallyKey, divideEqually);
  }


  Future<Map<String, dynamic>> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    

    return {
      'courtName': prefs.getString(_courtNameKey) ?? '',
      'courtRate': prefs.getDouble(_courtRateKey) ?? 0.0,
      'shuttlePrice': prefs.getDouble(_shuttlePriceKey) ?? 0.0,
      'divideEqually': prefs.getBool(_divideEquallyKey) ?? true,
    };
  }
}