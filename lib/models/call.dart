class Call {

  final String callerUid;
  final String callerName;
  final String callerPicture;
  final String recieverUid;
  final String recieverName;
  final String recieverPicture;
  final String callId;
  final bool hasDialled;
  Call({
    required this.callerUid,
    required this.callerName,
    required this.callerPicture,
    required this.recieverUid,
    required this.recieverName,
    required this.recieverPicture,
    required this.callId,
    required this.hasDialled,
  });

  


  Call copyWith({
    String? callerUid,
    String? callerName,
    String? callerPicture,
    String? recieverUid,
    String? recieverName,
    String? recieverPicture,
    String? callId,
    bool? hasDialled,
  }) {
    return Call(
      callerUid: callerUid ?? this.callerUid,
      callerName: callerName ?? this.callerName,
      callerPicture: callerPicture ?? this.callerPicture,
      recieverUid: recieverUid ?? this.recieverUid,
      recieverName: recieverName ?? this.recieverName,
      recieverPicture: recieverPicture ?? this.recieverPicture,
      callId: callId ?? this.callId,
      hasDialled: hasDialled ?? this.hasDialled,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'callerUid': callerUid,
      'callerName': callerName,
      'callerPicture': callerPicture,
      'recieverUid': recieverUid,
      'recieverName': recieverName,
      'recieverPicture': recieverPicture,
      'callId': callId,
      'hasDialled': hasDialled,
    };
  }

  factory Call.fromMap(Map<String, dynamic> map) {
    return Call(
      callerUid: map['callerUid'] as String,
      callerName: map['callerName'] as String,
      callerPicture: map['callerPicture'] as String,
      recieverUid: map['recieverUid'] as String,
      recieverName: map['recieverName'] as String,
      recieverPicture: map['recieverPicture'] as String,
      callId: map['callId'] as String,
      hasDialled: map['hasDialled'] as bool,
    );
  }

  @override
  String toString() {
    return 'Call(callerUid: $callerUid, callerName: $callerName, callerPicture: $callerPicture, recieverUid: $recieverUid, recieverName: $recieverName, recieverPicture: $recieverPicture, callId: $callId, hasDialled: $hasDialled)';
  }
}
