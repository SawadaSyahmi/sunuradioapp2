import 'package:just_audio/just_audio.dart';

import '../data/demo_data.dart';

class RadioPlayerController {
  RadioPlayerController._();
  static final RadioPlayerController instance = RadioPlayerController._();

  final AudioPlayer _player = AudioPlayer();
  bool _loaded = false;
  String? _loadedUrl;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  bool get isPlaying => _player.playing;

  String get streamUrl => appConfig.liveStreamUrl.trim();
  bool get hasStreamUrl => streamUrl.isNotEmpty;

  Future<void> toggle() async {
    if (_player.playing) {
      await _player.pause();
      return;
    }

    if (!hasStreamUrl) {
      throw StateError('Please add your live radio stream URL in Supabase app_config first.');
    }

    if (!_loaded || _loadedUrl != streamUrl) {
      await _player.setUrl(streamUrl);
      _loaded = true;
      _loadedUrl = streamUrl;
    }

    await _player.play();
  }

  Future<void> stop() async => _player.stop();
}
