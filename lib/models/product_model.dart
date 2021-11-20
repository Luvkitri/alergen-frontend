import 'dart:convert';

class ProductNotFoundException implements Exception {}

class ProductParseException implements Exception {}

class Product {
  late String code;
  // ignore: prefer_typing_uninitialized_variables
  late var raw;

  Product(String openfoodfactsJsonResponse, String code) {
    var resp = jsonDecode(openfoodfactsJsonResponse);
    if (!resp.containsKey("products")) {
      throw ProductParseException();
    }
    if (resp["products"].length <= 2) {
      // api always returns at least two entries
      // (those two have empty id so we can treat them as non existant)
      throw ProductNotFoundException();
    }
    // shit but works for now
    var found = false;
    for (var i = 0; i < resp["products"].length; i++) {
      if (resp["products"][i]["_id"] == code) {
        raw = resp["products"][i];
        found = true;
        break;
      }
    }
    if (!found) {
      throw ProductParseException();
    }
  }
}
