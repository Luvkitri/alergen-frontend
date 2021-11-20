import 'package:http/http.dart' as http;

class OpenfoodfactsService {
  static Uri url = Uri.parse('https://world.openfoodfacts.org/api/v2/');
  Future<bool> testConnectionToTheServer() async {
    try {
      http.Response resp = await http.get(url);
      return (resp.statusCode == 200);
    } on Exception {
      return false;
    }
  }
}
