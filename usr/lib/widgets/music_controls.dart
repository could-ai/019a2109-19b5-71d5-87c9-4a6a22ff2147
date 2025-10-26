import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';

class MusicControls extends StatelessWidget {
  const MusicControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          iconSize: 32,
          icon: const Icon(Icons.shuffle, color: Colors.white),
          onPressed: () {
            // TODO: Implement shuffle
          },
        ),
        IconButton(
          iconSize: 40,
          icon: const Icon(Icons.skip_previous, color: Colors.white),
          onPressed: () async {
            await AudioService.skipToPrevious();
          },
        ),
        StreamBuilder<PlaybackState>(
          stream: AudioService.playbackStateStream,
          builder: (context, snapshot) {
            final playing = snapshot.data?.playing ?? false;
            return IconButton(
              iconSize: 60,
              icon: Icon(
                playing ? Icons.pause_circle : Icons.play_circle,
                color: Colors.white,
              ),
              onPressed: () async {
                if (playing) {
                  await AudioService.pause();
                } else {
                  await AudioService.play();
                }
              },
            );
          },
        ),
        IconButton(
          iconSize: 40,
          icon: const Icon(Icons.skip_next, color: Colors.white),
          onPressed: () async {
            await AudioService.skipToNext();
          },
        ),
        IconButton(
          iconSize: 32,
          icon: const Icon(Icons.repeat, color: Colors.white),
          onPressed: () {
            // TODO: Implement repeat
          },
        ),
      ],
    );
  }
}