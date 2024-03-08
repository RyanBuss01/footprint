import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../classes/my_user.dart';
import '../../screens/map/frame.dart';

final url = dotenv.env['API_BASE_URL']!;
class UserService {

  Future<http.Response> attemptSignUp({required String email, required String password, required String firstName, required String lastName, required String displayName}) async {
    var res = await http.post(
        Uri.http(url, '/signup'),
        body: {
          "email": email,
          "password": password,
          "firstName": firstName,
          "lastName": lastName,
          "displayName": displayName,
        }
    );
    return res;
  }


  Future<http.Response> attemptLogIn(String email, String password) async {
    var res = await http.post(
        Uri.http(url, '/signin'),
        body: {
          "email": email,
          "password": password
        }
    );
    return res;
  }

  Future<MyUser> getMyUserdata(int? id, {isMe = false, isProfilePage = false, String? username, required Position pos}) async {
    var res = await http.get(
        Uri.http(url, '/getUserdata'),
        headers: {
          'id': id.toString(),
          'isme' : isMe.toString(),
          'myId' : isMe ? '' :  user.id.toString(),
          'username' : username ?? '',
          'querytype' : username == null ? 'byId' : 'byUsername'
        }
    );
    var json = await jsonDecode(res.body);
    return MyUser.fromDoc(json, isMe: isMe, isProfilePage: isProfilePage, pos: pos);
  }
}