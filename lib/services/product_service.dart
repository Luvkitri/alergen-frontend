import 'package:flutter/material.dart';
import 'package:frontend/locator.dart';
import 'package:frontend/models/product_model.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:http/http.dart' as http;

class ProductService {
  static String baseUrl = '10.0.2.2:8001';

  final AuthService _authService = locator<AuthService>();

  List<Product> usersSavedProducts = [];

  Future<void> saveUserProduct(String code) async {
    if (_authService.user == null) {
      return;
    }

    final requestBody = {'name': code};

    Uri uri = Uri.http(
      baseUrl,
      '/api/users/${_authService.user!.id}/products',
    );
    http.Response response =
        await http.post(uri, headers: {}, body: requestBody);

    debugPrint("saveUserProduct: $code");
    debugPrint(response.body);
  }

  Future<List<Product>> getUserProducts() async {
    if (_authService.user == null) {
      return [];
    }
    // final queryParameters = {
    //   // 'date_from': dateStart.toIso8601String().substring(0, 10),
    //   // 'date_to': dateEnd.toIso8601String().substring(0, 10),
    //   // 'lat': '${location.latitude}',
    //   // 'lon': '${location.longitude}'
    // };

    Uri uri = Uri.http(baseUrl, '/api/users/${_authService.user!.id}/products');
    http.Response response = await http.get(uri, headers: {});

    debugPrint("getUserProducts");
    debugPrint(response.body);
    return [];
  }
}
