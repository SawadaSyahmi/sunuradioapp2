import 'package:just_audio/just_audio.dart';

/// Temporary BBC test stream for the SUN4U Radio prototype.
///
/// Replace these with the official SUN4U Radio streaming endpoint later.
/// The first URL uses HTTPS for mobile compatibility; the second URL is a
/// fallback version of the same BBC World Service HLS stream.
const kRadioStreamUrls = <String>[
  'https://a.files.bbci.co.uk/media/live/manifesto/audio/simulcast/hls/nonuk/sbr_low/ak/bbc_world_service.m3u8',
  'http://a.files.bbci.co.uk/media/live/manifesto/audio/simulcast/hls/nonuk/sbr_low/ak/bbc_world_service.m3u8',
];

class RadioPlayerController {
  RadioPlayerController._();
  static final RadioPlayerController instance = RadioPlayerController._();

  final AudioPlayer _player = AudioPlayer();
  bool _loaded = false;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  bool get isPlaying => _player.playing;
  bool get hasStreamUrl => kRadioStreamUrls.any((url) => url.trim().isNotEmpty);

  Future<void> toggle() async {
    if (_player.playing) {
      await _player.pause();
      return;
    }

    if (!hasStreamUrl) {
      throw StateError('Please add your live radio stream URL first.');
    }

    if (!_loaded) {
      await _loadFirstWorkingStream();
      _loaded = true;
    }
    await _player.play();
  }

  Future<void> _loadFirstWorkingStream() async {
    Object? lastError;

    for (final url in kRadioStreamUrls) {
      if (url.trim().isEmpty) continue;

      try {
        await _player.setUrl(url);
        return;
      } catch (error) {
        lastError = error;
      }
    }

    throw StateError('Unable to load the BBC test stream. Last error: $lastError');
  }

  Future<void> stop() async => _player.stop();
}
