

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

import '../../../core/enums/message_enum.dart';
import 'video_player_widget.dart';

class DisplayMessage extends StatelessWidget {
  const DisplayMessage({super.key, required this.message, required this.type});

  final String message;
  final MessageEnum type;

  @override
  Widget build(BuildContext context) {
    
    bool isPlaying = false;
    final FlutterSoundPlayer audioPlayer = FlutterSoundPlayer();

    switch (type) {
      case MessageEnum.text:
        return Text(
          message,
          style: const TextStyle(
            fontSize: 16,
          ),
        );

      case MessageEnum.image:
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6)
          ),
          clipBehavior: Clip.antiAlias,
          child: CachedNetworkImage(
            imageUrl: message,
            fit: BoxFit.cover,
          ),
        );

      case MessageEnum.audio:
        return StatefulBuilder(
          builder: (context, state) {
            return IconButton(
              constraints: const BoxConstraints(
                minWidth: 100,
                minHeight: 100
              ),
              onPressed: () async {
                if (!audioPlayer.isOpen()) {
                  await audioPlayer.openPlayer();
                }
                if (isPlaying) {
                  await audioPlayer.pausePlayer();
                  state(() => isPlaying = false);
                } else {
                  await audioPlayer.startPlayer(fromURI: message);
                  state(() => isPlaying = true);
                }
              },
              icon: Icon(isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded),
            );
          },
        );

      case MessageEnum.video:
        return VideoPlayer(videoUrl: message);

      case MessageEnum.gif:
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6)
          ),
          clipBehavior: Clip.antiAlias,
          child: CachedNetworkImage(
            imageUrl: message,
            fit: BoxFit.cover,
          ),
        );
    }
    
  }
}