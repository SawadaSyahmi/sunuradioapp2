import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../core/app_colors.dart';
import '../services/radio_player_controller.dart';

class PlayButton extends StatelessWidget {
  const PlayButton({super.key, this.size = 58, this.filled = true});

  final double size;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: RadioPlayerController.instance.playerStateStream,
      builder: (context, snapshot) {
        final playing = snapshot.data?.playing ?? RadioPlayerController.instance.isPlaying;
        return InkWell(
          customBorder: const CircleBorder(),
          onTap: () async {
            try {
              await RadioPlayerController.instance.toggle();
            } on Object catch (error) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(error.toString().replaceFirst('Bad state: ', ''))),
              );
            }
          },
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filled ? Colors.white : Colors.white.withOpacity(.08),
              border: Border.all(color: Colors.white.withOpacity(.15)),
              boxShadow: filled
                  ? [BoxShadow(color: AppColors.orange.withOpacity(.30), blurRadius: 22)]
                  : null,
            ),
            child: Icon(
              playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: filled ? AppColors.orange : Colors.white,
              size: size * .46,
            ),
          ),
        );
      },
    );
  }
}
