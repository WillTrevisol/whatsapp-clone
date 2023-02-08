import '../core/enums/message_enum.dart';

class Message {
  final String senderUid;
  final String receiverUid;
  final String text;
  final MessageEnum type;
  final DateTime sentTime;
  final String messageId;
  final bool isSeen;
  Message({
    required this.senderUid,
    required this.receiverUid,
    required this.text,
    required this.type,
    required this.sentTime,
    required this.messageId,
    required this.isSeen,
  });

  Message copyWith({
    String? senderUid,
    String? receiverUid,
    String? text,
    MessageEnum? type,
    DateTime? sentTime,
    String? messageId,
    bool? isSeen,
  }) {
    return Message(
      senderUid: senderUid ?? this.senderUid,
      receiverUid: receiverUid ?? this.receiverUid,
      text: text ?? this.text,
      type: type ?? this.type,
      sentTime: sentTime ?? this.sentTime,
      messageId: messageId ?? this.messageId,
      isSeen: isSeen ?? this.isSeen,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderUid': senderUid,
      'receiverUid': receiverUid,
      'text': text,
      'type': type.type,
      'sentTime': sentTime.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderUid: map['senderUid'] as String,
      receiverUid: map['receiverUid'] as String,
      text: map['text'] as String,
      type: (map['type'] as String).toEnum(),
      sentTime: DateTime.fromMillisecondsSinceEpoch(map['sentTime'] as int),
      messageId: map['messageId'] as String,
      isSeen: map['isSeen'] as bool,
    );
  }

  @override
  String toString() {
    return 'Message(senderUid: $senderUid, receiverUid: $receiverUid, text: $text, type: $type, sentTime: $sentTime, messageId: $messageId, isSeen: $isSeen)';
  }
}
