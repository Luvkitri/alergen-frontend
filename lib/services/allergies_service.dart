import 'package:frontend/models/allergy_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AllergiesService {
  String urlS = 'http://10.0.2.2:8000/api/v1';

  List<Allergy> allergies = [];
  List<Allergy> userAllergies = [];

  Future getAllergiesList() async {
    if (allergies.isNotEmpty) {
      return allergies;
    }
    var resp = await http.get(Uri.parse(urlS + '/allergy'));
    if (resp.statusCode == 200) {
      dynamic all = jsonDecode(resp.body);
      for (Map<String, dynamic> a in all) {
        allergies.add(Allergy.fromData(a));
      }
      return allergies;
    } else {
      return null;
    }
  }

  Future getUserAllergiesList(String userid) async {
    var resp = await http.get(Uri.parse(urlS + '/user_allergy/' + userid));
    if (resp.statusCode == 200) {
      dynamic all = jsonDecode(resp.body);
      userAllergies = [];
      for (Map<String, dynamic> a in all) {
        userAllergies.add(Allergy.fromData(a));
        userAllergies.sort((a, b) => a.id.compareTo(b.id));
      }
      return userAllergies;
    } else {
      return null;
    }
  }

  Future saveUsersAllergies(String id, List<int> allergiesSelected) async {
    var resp = await http.post(Uri.parse(urlS + '/user_allergy/' + id),
        body: jsonEncode({'allergy_id': allergiesSelected}),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (resp.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
  Future deleteUsersAllergies(String id, List<int> allergiesSelected) async {
    var resp = await http.delete(Uri.parse(urlS + '/user_allergy/' + id),
        body: jsonEncode({'allergy_id': allergiesSelected}),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (resp.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }
}
