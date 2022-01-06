import 'package:frontend/models/allergy_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AllergiesService {
  String urlS = 'http://10.0.2.2:8000/api/v1';
  String urlSh = '10.0.2.2:8000';
  List<Allergy> allergies = [];
  List<Allergy> userAllergies = [];

  Future getAllergiesList() async {
    if (allergies.isNotEmpty) {
      return allergies;
    }
    var resp = await http.get(
      Uri.parse(urlS + '/allergies'),
    );
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
    var resp = await http.get(
      Uri.parse(urlS + '/users/' + userid + '/allergies/'),
    );
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
    var resp = await http.post(
      Uri.parse(urlS + '/users/' + id + '/allergies/'),
      body: jsonEncode(
        {
          'allergy_ids': allergiesSelected,
        },
      ),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (resp.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future deleteUsersAllergies(String id, List<int> allergiesSelected) async {
    var resp = await http.delete(
      Uri.http(
        urlSh,
        '/api/v1/users/$id/allergies/',
        {
          'allergy_ids': allergiesSelected.map((e) => e.toString()).toList(),
        },
      ),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (resp.statusCode == 200 || resp.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  Future getCrossAllergiesFromIdList(List<int> userAllergies) async {
    Uri temp = Uri.http(
      urlSh,
      'api/v1/cross-allergies',
      {
        'allergy_ids': userAllergies.map((e) => e.toString()).toList(),
      },
    );
    var resp = await http.get(temp);
    if (resp.statusCode == 200) {
      dynamic all = jsonDecode(resp.body);
      return all;
    } else {
      return null;
    }
  }
}
