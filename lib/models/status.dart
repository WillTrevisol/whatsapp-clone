class Status {

  final String uid;
  final String statusId;
  final String userName;
  final String phoneNumber;
  final String profilePicture;
  final List<String> photoUrl;
  final List<String> whoCanSee;
  final DateTime createdAt;
  Status({
    required this.uid,
    required this.statusId,
    required this.userName,
    required this.phoneNumber,
    required this.profilePicture,
    required this.photoUrl,
    required this.whoCanSee,
    required this.createdAt,
  });


  Status copyWith({
    String? uid,
    String? statusId,
    String? userName,
    String? phoneNumber,
    String? profilePicture,
    List<String>? photoUrl,
    List<String>? whoCanSee,
    DateTime? createdAt,
  }) {
    return Status(
      uid: uid ?? this.uid,
      statusId: statusId ?? this.statusId,
      userName: userName ?? this.userName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      photoUrl: photoUrl ?? this.photoUrl,
      whoCanSee: whoCanSee ?? this.whoCanSee,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'statusId': statusId,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'photoUrl': photoUrl,
      'whoCanSee': whoCanSee,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      uid: map['uid'] as String,
      statusId: map['statusId'] as String,
      userName: map['userName'] as String,
      phoneNumber: map['phoneNumber'] as String,
      profilePicture: map['profilePicture'] as String,
      photoUrl: List<String>.from(map['photoUrl']),
      whoCanSee: List<String>.from(map['whoCanSee']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  @override
  String toString() {
    return 'Status(uid: $uid, statusId: $statusId, userName: $userName, phoneNumber: $phoneNumber, profilePicture: $profilePicture, photoUrl: $photoUrl, whoCanSee: $whoCanSee, createdAt: $createdAt)';
  }
}
