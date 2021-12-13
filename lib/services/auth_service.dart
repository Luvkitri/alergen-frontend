import 'dart:convert';

import 'package:frontend/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthService {
  String urlS = 'http://10.0.2.2:8000/api/v1';

  User? user;

  Future<String?> getNewUserID() async {
    var resp = await http.get(Uri.parse(urlS + '/users/init'));
    if (resp.statusCode == 200) {
      String userid = jsonDecode(resp.body);
      user = User(userid);
      return userid;
    } else {
      return null;
    }
  }

  Future getUser(String userid) async {
    var resp = await http.get(
      Uri.parse(urlS + '/users/' + userid),
    );

    if (resp.statusCode == 200) {
      var userResp = jsonDecode(resp.body);
      // if current userid not in database, get new userid
      if (userResp == null) {
        String? userid = await getNewUserID();
        return userid;
      }
      String userid = userResp['id'];
      user = User.fromData(userResp);
      return userid;
    } else {
      return null;
    }
  }

  Future<bool> updateUser(User user) async {
    var resp = await http.put(Uri.parse(urlS + '/users/' + user.id),
        body: jsonEncode(user.toJson()),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (resp.statusCode == 200) {
      this.user = user;
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteUser() async {
    var resp = await http.delete(
      Uri.parse(urlS + '/users/' + user!.id),
    );
    if (resp.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }
}
