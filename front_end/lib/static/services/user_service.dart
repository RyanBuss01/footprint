import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final url = dotenv.env['API_BASE_URL']!;
class UserService {

  Future<http.Response> attemptSignUp({required String email, required String password, required String firstName, required String lastName, required String displayName, required String username, required DateTime birthday}) async {
    var res = await http.post(
        Uri.http(url, '/signup'),
        body: {
          "email": email,
          "password": password,
          "firstName": firstName,
          "lastName": lastName,
          "username" : username,
          "displayName": displayName,
          "birthday": birthday.toString()
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
}