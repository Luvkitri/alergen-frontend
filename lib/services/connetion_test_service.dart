import 'package:http/http.dart' as http;

class ConnectionTestService {
  var url = Uri.parse('127.0.0.1');
  Future testConnectionToTheServer() async {
    var resp = await http.get(url);
    if (resp.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
