import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/agora_config.dart';
import '../../../core/common/widgets/loading_widget.dart';
import '../../../models/call.dart';
import '../controller/call_controller.dart';

class CallScreen extends ConsumerStatefulWidget {
  const CallScreen({
    super.key, 
    required this.call, 
    required this.channelId,
    required this.isGroupChat,
  });

  final String channelId;
  final Call call;
  final bool isGroupChat;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {

  AgoraClient? agoraClient;
  String baseUrl = '';

  @override
  void initState() {
    super.initState();
    agoraClient = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: AgoraConfig.appId,
        channelName: widget.channelId,
        tokenUrl: baseUrl,
      ),
    );
    initAgora();
  }

  void initAgora() async {
    await agoraClient!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: agoraClient == null ? const LoadingWidget() :
      SafeArea(
        child: Stack(
          children: <Widget> [
            AgoraVideoViewer(client: agoraClient!),
            AgoraVideoButtons(
              client: agoraClient!,
              disconnectButtonChild: IconButton(
                onPressed: () async {
                  await agoraClient!.engine.leaveChannel();
                  // ignore: use_build_context_synchronously
                  ref.read(callControllerProvider).endCall(context, widget.call.callerUid, widget.call.recieverUid); 
                },
                icon: const Icon(
                  Icons.call_end,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
