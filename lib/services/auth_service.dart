import 'dart:convert';

import 'package:frontend/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthService {
  String urlS = 'http://10.0.2.2:8000';
  var url = Uri.parse('http://10.0.2.2:8000'); // ustawić dla swojego urządzenia

  User? user;

  Future<String?> getNewUserID() async {
    var resp = await http.get(url);
    if (resp.statusCode == 200) {
      String userid = jsonDecode(resp.body)['userid'];
      user = User(userid);
      return userid;
    } else {
      return null;
    }
  }

  Future getUser(String userid) async {
    var resp = await http.get(Uri.parse(urlS + '/users/get/' + userid));
    if (resp.statusCode == 200) {
      var userResp = jsonDecode(resp.body);
      String userid = userResp['userid'];
      user = User.fromData(userResp);
      return userid;
    } else {
      return null;
    }
  }
}
