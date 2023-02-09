import 'package:flutter/material.dart';
import 'package:cached_video_player/cached_video_player.dart';

class VideoPlayer extends StatefulWidget {
  const VideoPlayer({super.key, required this.videoUrl});

  final String videoUrl;

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late CachedVideoPlayerController controller;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    controller = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize().then((
        value) => controller.setVolume(1),
      );
  }
  
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: <Widget> [
          CachedVideoPlayer(controller),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {
                if (isPlaying) {
                  controller.pause();
                } else {
                  controller.play();
                }
                setState(() => isPlaying = !isPlaying);
              },
              icon: Icon(!isPlaying ? Icons.play_circle_fill_rounded : Icons.pause_circle_filled_rounded)
            ),
          )
        ],
      ),
    );
  }
}