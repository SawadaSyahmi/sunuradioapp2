import 'package:shared_preferences/shared_preferences.dart';

class PlaybackSettings {
  const PlaybackSettings._();

  static const _backgroundKey = 'sun4u_play_in_background';

  static Future<bool> backgroundPlaybackEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_backgroundKey) ?? true;
  }

  static Future<void> setBackgroundPlaybackEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_backgroundKey, value);
  }
}
