import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:whatsapp_clone/core/common/widgets/loading_widget.dart';

import '../../../models/status.dart';

class StatusScreen extends StatefulWidget {
  static const String routeName = '/status-scren';
  const StatusScreen({super.key, required this.status});

  final Status status;

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {

  StoryController storyController = StoryController();
  List<StoryItem> storyItems = [];

  @override
  void initState() {
    super.initState();
    initStoryPageItems();
  }

  void initStoryPageItems() {
    for (int i = 0; i < widget.status.photoUrl.length; i++) {
      storyItems.add(
        StoryItem.pageImage(url: widget.status.photoUrl[i], controller: storyController),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: storyItems.isEmpty ? const LoadingWidget() : 
      StoryView(
        storyItems: storyItems, 
        controller: storyController,
        onVerticalSwipeComplete: (Direction? direction) {
          if (direction == Direction.down) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}