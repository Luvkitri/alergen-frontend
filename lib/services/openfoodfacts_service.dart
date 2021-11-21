import 'package:frontend/models/product_model.dart';
import 'package:http/http.dart' as http;

class OpenfoodfactsService {
  static String baseUrl = 'https://world.openfoodfacts.org/api/v2/';
  static String searchUrl = 'https://world.openfoodfacts.org/api/v2/search/';
  static String fieldsQuery =
      '?fields=code,product_name,allergens,allergens_hierarchy,allergens_tags,ingredients,image_url,image_thumb_url,categories_hierarchy,url';

  static String? currentCode;
  void setCurrentCode(String code) {
    currentCode = code;
  }

  Future<bool> testConnectionToTheServer() async {
    try {
      http.Response resp = await http.get(Uri.parse(baseUrl));
      return (resp.statusCode == 200);
    } on Exception {
      return false;
    }
  }

  Future<Product> findProduct() async {
    String code = currentCode!;
    Uri productQueryUrl = Uri.parse(searchUrl + code + fieldsQuery);
    print(productQueryUrl);
    http.Response resp;
    try {
      resp = await http.get(productQueryUrl);
    } on Exception {
      throw ProductNotFoundException;
    }

    Product p = Product(resp.body, currentCode!);
    p.code = code;
    return p;
  }
}
