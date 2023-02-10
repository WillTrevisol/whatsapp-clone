class Group {
  final String name;
  final String groupId;
  final String lastMessage;
  final String lastSenderUid;
  final String groupProfilePicture;
  final List<String> membersUid;
  final DateTime sentTime;
  Group({
    required this.name,
    required this.groupId,
    required this.lastMessage,
    required this.lastSenderUid,
    required this.groupProfilePicture,
    required this.membersUid,
    required this.sentTime,
  });



  Group copyWith({
    String? name,
    String? groupId,
    String? lastMessage,
    String? lastSenderUid,
    String? profilePicture,
    String? groupProfilePicture,
    List<String>? membersUid,
    DateTime? sentTime,
  }) {
    return Group(
      name: name ?? this.name,
      groupId: groupId ?? this.groupId,
      lastMessage: lastMessage ?? this.lastMessage,
      lastSenderUid: lastSenderUid ?? this.lastSenderUid,
      groupProfilePicture: groupProfilePicture ?? this.groupProfilePicture,
      membersUid: membersUid ?? this.membersUid,
      sentTime: sentTime ?? this.sentTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'groupId': groupId,
      'lastMessage': lastMessage,
      'lastSenderUid': lastSenderUid,
      'groupProfilePicture': groupProfilePicture,
      'membersUid': membersUid,
      'sentTime': sentTime.millisecondsSinceEpoch,
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      name: map['name'] as String,
      groupId: map['groupId'] as String,
      lastMessage: map['lastMessage'] as String,
      lastSenderUid: map['lastSenderUid'] as String,
      groupProfilePicture: map['groupProfilePicture'] as String,
      membersUid: List<String>.from(map['membersUid']),
      sentTime: DateTime.fromMillisecondsSinceEpoch(map['sentTime'] as int)
    );
  }

  @override
  String toString() {
    return 'Group(name: $name, groupId: $groupId, lastMessage: $lastMessage, lastSenderUid: $lastSenderUid, groupProfilePicture: $groupProfilePicture, membersUid: $membersUid)';
  }

}
