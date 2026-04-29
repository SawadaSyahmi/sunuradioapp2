import 'package:just_audio/just_audio.dart';

/// Temporary BBC World Service test stream for the SUN4U Radio prototype.
/// Replace [streamUrl] with the official SUN4U Radio endpoint later.
class RadioPlayerController {
  RadioPlayerController._();
  static final RadioPlayerController instance = RadioPlayerController._();

  static const String streamUrl = 'https://stream.live.vc.bbcmedia.co.uk/bbc_world_service';

  final AudioPlayer _player = AudioPlayer();
  bool _loaded = false;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  bool get isPlaying => _player.playing;
  bool get hasStreamUrl => streamUrl.trim().isNotEmpty;

  Future<void> toggle() async {
    if (_player.playing) {
      await _player.pause();
      return;
    }

    if (!hasStreamUrl) {
      throw StateError('Please add your live radio stream URL first.');
    }

    if (!_loaded) {
      await _player.setUrl(streamUrl);
      _loaded = true;
    }

    await _player.play();
  }

  Future<void> stop() async => _player.stop();
}
