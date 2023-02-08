class UserModel {
  final String name;
  final String uid;
  final String profilePicture;
  final bool isOnline;
  final String phoneNumber;
  final List<String> groupsId;
  UserModel({
    required this.name,
    required this.uid,
    required this.profilePicture,
    required this.isOnline,
    required this.phoneNumber,
    required this.groupsId,
  });
  


  UserModel copyWith({
    String? name,
    String? uid,
    String? profilePicture,
    bool? isOnline,
    String? phoneNumber,
    List<String>? groupsId,
  }) {
    return UserModel(
      name: name ?? this.name,
      uid: uid ?? this.uid,
      profilePicture: profilePicture ?? this.profilePicture,
      isOnline: isOnline ?? this.isOnline,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      groupsId: groupsId ?? this.groupsId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'uid': uid,
      'profilePicture': profilePicture,
      'isOnline': isOnline,
      'phoneNumber': phoneNumber,
      'groupsId': groupsId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      uid: map['uid'] as String,
      profilePicture: map['profilePicture'] as String,
      isOnline: map['isOnline'] as bool,
      phoneNumber: map['phoneNumber'] as String,
      groupsId: List<String>.from(map['groupsId']),
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, uid: $uid, profilePicture: $profilePicture, isOnline: $isOnline, phoneNumber: $phoneNumber, groupsId: $groupsId)';
  }
}
