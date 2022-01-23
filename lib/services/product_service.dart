import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/locator.dart';
import 'package:frontend/models/product_model.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:http/http.dart' as http;

class ProductService {
  static String baseUrl = '10.0.2.2:8000';

  final AuthService _authService = locator<AuthService>();

  List<String> usersSavedProducts = [];

  Future<void> saveUserProduct(String code) async {
    if (_authService.user == null) {
      return;
    }

    final requestBody = {'name': code};

    Uri uri = Uri.http(
      baseUrl,
      '/api/v1/users/${_authService.user!.id}/products/',
    );
    http.Response response = await http.post(uri,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody));

    debugPrint("saveUserProduct: $code");
    debugPrint(response.body);

    await getUserProducts();
  }

  Future<List<String>> getUserProducts() async {
    if (_authService.user == null) {
      return [];
    }

    Uri uri =
        Uri.http(baseUrl, '/api/v1/users/${_authService.user!.id}/products/');
    http.Response response = await http
        .get(uri, headers: {'Content-Type': 'application/json; charset=UTF-8'});

    debugPrint("getUserProducts");
    debugPrint(response.body);

    usersSavedProducts = [];

    for (var productObj in jsonDecode(response.body)) {
      usersSavedProducts.add(productObj["name"]);
    }

    return usersSavedProducts;
  }

  Future<void> deleteUserProduct(String code) async {
    if (_authService.user == null) {
      return;
    }

    Uri uri = Uri.http(
      baseUrl,
      '/api/v1/users/${_authService.user!.id}/products/',
      {
        'product_ids': [code],
      },
    );

    await http.delete(uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'});

    await getUserProducts();
  }
}
