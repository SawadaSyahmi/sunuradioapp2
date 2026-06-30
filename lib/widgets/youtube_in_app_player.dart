import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YouTubeInAppPlayer extends StatefulWidget {
  const YouTubeInAppPlayer({super.key, required this.videoUrl});

  final String videoUrl;

  @override
  State<YouTubeInAppPlayer> createState() => _YouTubeInAppPlayerState();
}

class _YouTubeInAppPlayerState extends State<YouTubeInAppPlayer> {
  YoutubePlayerController? _controller;
  String? _videoId;

  @override
  void initState() {
    super.initState();
    _load(widget.videoUrl);
  }

  @override
  void didUpdateWidget(covariant YouTubeInAppPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _controller?.close();
      _load(widget.videoUrl);
    }
  }

  void _load(String url) {
    _videoId = YouTubeUrlParser.videoIdFromUrl(url);
    if (_videoId == null) {
      _controller = null;
      return;
    }

    _controller = YoutubePlayerController.fromVideoId(
      videoId: _videoId!,
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        playsInline: true,
        strictRelatedVideos: true,
        //privacyEnhancedMode: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null || _videoId == null) {
      return Container(
        color: Colors.black,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: const Text(
          'Video link is not a valid YouTube URL.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      );
    }

    return YoutubePlayer(
      controller: controller,
      aspectRatio: 16 / 9,
    );
  }
}

class YouTubeUrlParser {
  const YouTubeUrlParser._();

  static String? videoIdFromUrl(String input) {
    final raw = input.trim();
    if (raw.isEmpty) return null;

    final idOnly = RegExp(r'^[a-zA-Z0-9_-]{11}$');
    if (idOnly.hasMatch(raw)) return raw;

    final uri = Uri.tryParse(raw);
    if (uri == null) return null;

    final host = uri.host.toLowerCase().replaceFirst('www.', '').replaceFirst('m.', '');

    if (host == 'youtu.be') {
      final segment = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '';
      return idOnly.hasMatch(segment) ? segment : null;
    }

    if (host.endsWith('youtube.com') || host.endsWith('youtube-nocookie.com')) {
      final videoQuery = uri.queryParameters['v'];
      if (videoQuery != null && idOnly.hasMatch(videoQuery)) return videoQuery;

      final segments = uri.pathSegments;
      final embedIndex = segments.indexOf('embed');
      if (embedIndex >= 0 && segments.length > embedIndex + 1) {
        final id = segments[embedIndex + 1];
        return idOnly.hasMatch(id) ? id : null;
      }

      final shortsIndex = segments.indexOf('shorts');
      if (shortsIndex >= 0 && segments.length > shortsIndex + 1) {
        final id = segments[shortsIndex + 1];
        return idOnly.hasMatch(id) ? id : null;
      }
    }

    return null;
  }
}
