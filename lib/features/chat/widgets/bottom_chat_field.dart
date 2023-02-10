import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_clone/core/common/utils/utils.dart';

import '../../../core/common/utils/colors.dart';
import '../../../core/enums/message_enum.dart';
import '../../../core/providers/message_reply_provider.dart';
import '../controller/chat_controller.dart';
import 'message_reply_preview.dart';

class BottomChatField extends ConsumerStatefulWidget {
  const BottomChatField({
    super.key,
    required this.recieverUserUid,
    required this.isGroupChat,
  });

  final String recieverUserUid;
  final bool isGroupChat;

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {

  final TextEditingController _messageController = TextEditingController();
  FlutterSoundRecorder? _flutterSoundRecorder;
  bool isRecorderInitialized = false;
  bool isRecording = false;
  bool showSendButton = false;
  bool showEmojis = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _flutterSoundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _flutterSoundRecorder?.closeRecorder();
    isRecorderInitialized = false;
  }

  void openAudio() async {
    final permissionStatus = await Permission.microphone.request();

    if (permissionStatus != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone perssion not allowed!');
    }
    await _flutterSoundRecorder!.openRecorder();
    isRecorderInitialized = true;
  }

  void sendTextMessage() async {
    if (showSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
        context, 
        _messageController.text.trim(),
        widget.recieverUserUid,
        widget.isGroupChat,
        );
      setState(() {
        _messageController.text = '';
        showSendButton = false;
      });
    } else {
      final temporaryDir = await getTemporaryDirectory();
      final path = '${temporaryDir.path}/flutter_sound_record.aac';
      if(!isRecorderInitialized) {
        return;
      }
      if (isRecording) {
        await _flutterSoundRecorder?.stopRecorder();
        sendFileMessage(File(path), MessageEnum.audio);
      } else {
        await _flutterSoundRecorder?.startRecorder(
          toFile: path,
        );
      }
      setState(() => isRecording = !isRecording);
    }
  }

  void sendFileMessage(File file, MessageEnum messageEnum) {
    ref.read(chatControllerProvider).sendFileMessage(
      context, 
      file, 
      widget.recieverUserUid, 
      messageEnum, 
      widget.isGroupChat,
    );
  }

  void sendGifMessage(String gifUrl) {
    ref.read(chatControllerProvider).sendGifMessage(
      context, 
      gifUrl, 
      widget.recieverUserUid,
      widget.isGroupChat,
    );
  }
  
  void selectImageFromGalery() async {
    File? image = await pickImageFromGalery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectImageFromCamera() async {
    File? image = await pickImageFromCamera(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGalery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  void selectGIF() async {
    final gif = await pickGIF(context);
    if (gif != null) {
      sendGifMessage(gif.url!);
    }
  }

  void hideEmojiContainer() {
    setState(() => showEmojis = false);
  }

  void showEmojiContainer() {
    setState(() => showEmojis = true);
  }

  void toggleKeyboard() {
    if (showEmojis) {
      if (focusNode.hasFocus) {
        showKeyBoard();
      }
      hideEmojiContainer();
    } else {
      hideKeyBoard();
      showEmojiContainer();
    }
  }

  void showKeyBoard() => focusNode.requestFocus();
  void hideKeyBoard() => focusNode.unfocus();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final messageReply = ref.watch(messageReplyProvider);
    final showMessageReplyPreview = messageReply != null;

    return Column(
      children: <Widget> [
        if (showMessageReplyPreview)
          const MessageReplyPreview(),
        Row(
          children: <Widget> [
            Expanded(
              child: TextField(
                focusNode: focusNode,
                controller: _messageController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mobileChatBoxColor,
                  prefixIcon: SizedBox(
                    width: size.width * 0.1,
                    child: IconButton(
                      splashRadius: 1,
                      onPressed: () => toggleKeyboard(),
                      icon: const Icon(
                        Icons.emoji_emotions_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: size.width * 0.30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget> [
                        IconButton(
                          splashRadius: 1,
                          onPressed: () => selectImageFromCamera(),
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          splashRadius: 1,
                          onPressed: () {
                            showModalBottomSheet(
                              context: context, 
                              builder: (context) {
                                return SizedBox(
                                  height: size.height * 0.2,
                                  child: Center(
                                    child: GridView(
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                                      children: <Widget> [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            selectImageFromGalery();
                                          },
                                          icon: const Icon(
                                            Icons.camera_alt,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            selectVideo();
                                          },
                                          icon: const Icon(
                                            Icons.video_camera_back_rounded,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            selectGIF();
                                          },
                                          icon: const Icon(
                                            Icons.gif,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(
                                            Icons.audio_file_rounded,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                  hintText: 'Message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(()=> showSendButton = true);
                  }
                  if (value.isEmpty) {
                    setState(()=> showSendButton = false);
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              child: GestureDetector(
                onTap: () => sendTextMessage(),
                child: CircleAvatar(
                  backgroundColor: const Color(0xFF128C7E),
                  radius: 22,
                  child: Icon(
                    showSendButton 
                      ? Icons.send_rounded 
                      : isRecording ? Icons.close : Icons.mic_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (showEmojis) 
          SizedBox(
            height: 300,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                setState(() => _messageController.text += emoji.emoji);
    
                if (!showSendButton) {
                  setState(() => showSendButton = true);
                }
              },
            ),
          ),
      ],
    );
  }
}