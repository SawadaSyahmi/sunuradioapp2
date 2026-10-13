import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../data/demo_data.dart';
import 'playback_settings.dart';
import 'safe_url.dart';

class RadioPlayerController {
  RadioPlayerController._();
  static final RadioPlayerController instance = RadioPlayerController._();

  final AudioPlayer _player = AudioPlayer();
  bool _loaded = false;
  String? _loadedUrl;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  bool get isPlaying => _player.playing;

  String get streamUrl => appConfig.liveStreamUrl.trim();
  bool get hasStreamUrl => SafeUrl.https(streamUrl) != null;

  Future<void> toggle() async {
    if (_player.playing) {
      await _player.pause();
      return;
    }

    final uri = SafeUrl.https(streamUrl);
    if (uri == null) {
      throw StateError('The live radio stream must be a valid HTTPS URL.');
    }

    if (!_loaded || _loadedUrl != streamUrl) {
      await _player.setAudioSource(
        AudioSource.uri(
          uri,
          tag: MediaItem(
            id: uri.toString(),
            album: appConfig.stationName,
            title: currentShow.title,
            artist: currentShow.host,
            artUri: SafeUrl.https(currentShow.artworkUrl),
          ),
        ),
      );
      _loaded = true;
      _loadedUrl = streamUrl;
    }

    await _player.play();
  }

  Future<void> handleLifecycle(AppLifecycleState state) async {
    if (state != AppLifecycleState.paused && state != AppLifecycleState.detached) return;
    final allowBackground = await PlaybackSettings.backgroundPlaybackEnabled();
    if (!allowBackground && _player.playing) {
      await _player.pause();
    }
  }

  Future<void> stop() async => _player.stop();
}
