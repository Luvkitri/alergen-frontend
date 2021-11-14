import 'package:http/http.dart' as http;

class ConnectionTestService {
  var url = Uri.parse('http://10.0.2.2:8000'); // ustawić dla swojego urządzenia
  Future testConnectionToTheServer() async {
    var resp = await http.get(url);
    if (resp.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
