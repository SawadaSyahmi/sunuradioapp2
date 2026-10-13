import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../core/app_colors.dart';
import '../services/safe_url.dart';
import '../widgets/youtube_in_app_player.dart' show YouTubeUrlParser;

class AdaptiveVideoPlayerScreen extends StatelessWidget {
  const AdaptiveVideoPlayerScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.videoUrl,
    this.artworkUrl = '',
  });

  final String title;
  final String subtitle;
  final String videoUrl;
  final String artworkUrl;

  @override
  Widget build(BuildContext context) {
    final safeUri = SafeUrl.https(videoUrl);
    if (safeUri == null) {
      return _InvalidVideoPage(title: title);
    }
    final safeUrl = safeUri.toString();
    final youtubeId = SafeUrl.isYoutube(safeUrl) ? YouTubeUrlParser.videoIdFromUrl(safeUrl) : null;
    if (youtubeId != null && youtubeId.isNotEmpty) {
      return _YoutubeVideoPage(
        videoId: youtubeId,
        title: title,
        subtitle: subtitle,
      );
    }

    return _DirectVideoPage(
      url: safeUrl,
      title: title,
      subtitle: subtitle,
      artworkUrl: artworkUrl,
    );
  }
}

class _InvalidVideoPage extends StatelessWidget {
  const _InvalidVideoPage({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, title: const Text('SUN4U Video')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            '$title\n\nThis video link is invalid or is not using HTTPS.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      ),
    );
  }
}

class _YoutubeVideoPage extends StatefulWidget {
  const _YoutubeVideoPage({
    required this.videoId,
    required this.title,
    required this.subtitle,
  });

  final String videoId;
  final String title;
  final String subtitle;

  @override
  State<_YoutubeVideoPage> createState() => _YoutubeVideoPageState();
}

class _YoutubeVideoPageState extends State<_YoutubeVideoPage> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        enableCaption: true,
        playsInline: true,
        strictRelatedVideos: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    // The iframe player manages fullscreen itself. Resetting the mobile app
    // orientation here keeps the rest of SUN4U portrait-first after exit.
    if (!kIsWeb) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations(const [DeviceOrientation.portraitUp]);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      controller: _controller,
      aspectRatio: 16 / 9,
      backgroundColor: Colors.black,
      fullscreenOrientations: const [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
      lockedOrientations: const [DeviceOrientation.portraitUp],
      builder: (context, player) {
        return Scaffold(
          backgroundColor: const Color(0xFF050505),
          body: OrientationBuilder(
            builder: (context, orientation) {
              // A normal desktop browser is usually landscape-shaped. Do not
              // mistake that for fullscreen; keep the title/details visible.
              final mobileLandscape = !kIsWeb && orientation == Orientation.landscape;
              if (mobileLandscape) {
                return SafeArea(child: Center(child: player));
              }

              return _PortraitVideoLayout(
                title: widget.title,
                subtitle: widget.subtitle,
                player: player,
                onBack: () => Navigator.pop(context),
              );
            },
          ),
        );
      },
    );
  }
}

class _DirectVideoPage extends StatefulWidget {
  const _DirectVideoPage({required this.url, required this.title, required this.subtitle, required this.artworkUrl});

  final String url;
  final String title;
  final String subtitle;
  final String artworkUrl;

  @override
  State<_DirectVideoPage> createState() => _DirectVideoPageState();
}

class _DirectVideoPageState extends State<_DirectVideoPage> {
  VideoPlayerController? _controller;
  Future<void>? _initializeFuture;
  bool _fullScreen = false;

  @override
  void initState() {
    super.initState();
    final uri = Uri.tryParse(widget.url.trim());
    if (uri != null && uri.hasScheme) {
      _controller = VideoPlayerController.networkUrl(uri);
      _initializeFuture = _controller!.initialize().then((_) {
        if (!mounted) return;
        _controller!.play();
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations(const [DeviceOrientation.portraitUp]);
    super.dispose();
  }

  Future<void> _toggleFullScreen() async {
    _fullScreen = !_fullScreen;
    if (_fullScreen) {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      await SystemChrome.setPreferredOrientations(const [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    } else {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      await SystemChrome.setPreferredOrientations(const [DeviceOrientation.portraitUp]);
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: OrientationBuilder(
        builder: (context, orientation) {
          final landscape = orientation == Orientation.landscape;
          final player = _buildPlayer(landscape: landscape);
          if (landscape) return player;
          return _PortraitVideoLayout(
            title: widget.title,
            subtitle: widget.subtitle,
            player: player,
            onBack: () => Navigator.pop(context),
          );
        },
      ),
    );
  }

  Widget _buildPlayer({required bool landscape}) {
    final controller = _controller;
    if (controller == null || _initializeFuture == null) {
      return _VideoError(message: 'This video URL is empty or invalid.', artworkUrl: widget.artworkUrl);
    }

    return FutureBuilder<void>(
      future: _initializeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator(color: AppColors.orange));
        }
        if (!controller.value.isInitialized) {
          return _VideoError(message: 'Unable to load this video.', artworkUrl: widget.artworkUrl);
        }

        final aspect = controller.value.aspectRatio <= 0 ? 16 / 9 : controller.value.aspectRatio;
        return Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (landscape)
                Positioned.fill(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: SizedBox(
                      width: controller.value.size.width,
                      height: controller.value.size.height,
                      child: VideoPlayer(controller),
                    ),
                  ),
                )
              else
                AspectRatio(aspectRatio: aspect, child: VideoPlayer(controller)),
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {
                      controller.value.isPlaying ? controller.pause() : controller.play();
                    });
                  },
                ),
              ),
              if (!controller.value.isPlaying)
                IgnorePointer(
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(color: Colors.black.withOpacity(.52), shape: BoxShape.circle),
                    child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 48),
                  ),
                ),
              Positioned(
                left: 14,
                right: 14,
                bottom: 12,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          controller.value.isPlaying ? controller.pause() : controller.play();
                        });
                      },
                      icon: Icon(controller.value.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.white),
                    ),
                    Expanded(
                      child: VideoProgressIndicator(
                        controller,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                          playedColor: AppColors.orange,
                          bufferedColor: Colors.white38,
                          backgroundColor: Colors.white24,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _toggleFullScreen,
                      icon: Icon(_fullScreen ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PortraitVideoLayout extends StatelessWidget {
  const _PortraitVideoLayout({required this.title, required this.subtitle, required this.player, required this.onBack});

  final String title;
  final String subtitle;
  final Widget player;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            height: 54,
            color: Colors.black,
            child: Row(
              children: [
                IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back_rounded, color: Colors.white)),
                const Expanded(
                  child: Text('SUN4U Video', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          ),
          AspectRatio(aspectRatio: 16 / 9, child: player),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(gradient: AppColors.blueGradient),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 34),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('NOW PLAYING', style: TextStyle(color: AppColors.orange, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: .8)),
                    const SizedBox(height: 10),
                    Text(title, style: const TextStyle(color: Colors.white, fontSize: 25, height: 1.02, fontWeight: FontWeight.w900)),
                    if (subtitle.trim().isNotEmpty) ...[
                      const SizedBox(height: 9),
                      Text('with $subtitle', style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                    const SizedBox(height: 18),
                    const Row(
                      children: [
                        Icon(Icons.screen_rotation_rounded, color: Colors.white70, size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Rotate your phone for a clean horizontal player. Full-screen controls are available in both portrait and landscape.',
                            style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.35),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoError extends StatelessWidget {
  const _VideoError({required this.message, required this.artworkUrl});

  final String message;
  final String artworkUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.video_library_outlined, color: Colors.white54, size: 46),
          const SizedBox(height: 10),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
