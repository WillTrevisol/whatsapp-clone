class ChatContact {
  final String name;
  final String profilePicture;
  final String contactUid;
  final DateTime timeSent;
  final String lastMessage;
  ChatContact({
    required this.name,
    required this.profilePicture,
    required this.contactUid,
    required this.timeSent,
    required this.lastMessage,
  });


  ChatContact copyWith({
    String? name,
    String? profilePicture,
    String? contactUid,
    DateTime? timeSent,
    String? lastMessage,
  }) {
    return ChatContact(
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
      contactUid: contactUid ?? this.contactUid,
      timeSent: timeSent ?? this.timeSent,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePicture': profilePicture,
      'contactUid': contactUid,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
    };
  }

  factory ChatContact.fromMap(Map<String, dynamic> map) {
    return ChatContact(
      name: map['name'] as String,
      profilePicture: map['profilePicture'] as String,
      contactUid: map['contactUid'] as String,
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
      lastMessage: map['lastMessage'] as String,
    );
  }

  @override
  String toString() {
    return 'ChatContact(name: $name, profilePicture: $profilePicture, contactUid: $contactUid, timeSent: $timeSent, lastMessage: $lastMessage)';
  }

}
