class UserDataModel {
  final String name;
  final String uid;
  final String profilePic;
  final bool isOnline;
  final String phoneNumber;
  final List<String> groupId;
  UserDataModel({
    required this.name,
    required this.uid,
    required this.profilePic,
    required this.isOnline,
    required this.phoneNumber,
    required this.groupId,
  });

  factory UserDataModel.fromMap(Map<String, dynamic> map) {
    return UserDataModel(
      name: map['user_name'] ?? '',
      uid: map['user_id'] ?? '',
      profilePic: map['url_image'] ?? '',
      isOnline: map['user_state'] ?? false,
      phoneNumber: map['user_phone'] ?? '',
      groupId: List<String>.from(map['user_groups']),
    );
  }
}
