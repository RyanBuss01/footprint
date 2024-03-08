import 'package:geolocator/geolocator.dart';

class MyUser {
 final int id;
  final String? email;
  final String displayName;
  final String username;
  final String? bio;
  final String avatar;
  Position currentPosition;


  MyUser({
    required this.id,
    this.email,
    required this.displayName,
    required this.username,
    this.bio,
    required this.avatar,
    required this.currentPosition,
  });


  factory MyUser.fromDoc(dynamic json,
      {isProfilePage = false, isPersonalData = false, isMe = false, int? count, required Position pos}) {
    return MyUser(
        id: json['user_id'],
        email: isPersonalData ? json['email'] : null,
        displayName: json['displayName'],
        username: json['username'],
        bio: isProfilePage || isMe ? json['bio'] : null,
        avatar: json['avatar'],
      currentPosition: pos,
    );
  } 
}