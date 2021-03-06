import 'dart:convert';

class ProductNotFoundException implements Exception {}

class ProductParseException implements Exception {}

class Product {
  static const String missingPhotoUrl =
      'https://upload.wikimedia.org/wikipedia/commons/b/b1/Missing-image-232x150.png';

  late String code;
  // ignore: prefer_typing_uninitialized_variables
  late var raw;

  late String name = "(unknown)";
  late String? imageUrl = Product.missingPhotoUrl;
  late String? imageThumbUrl = Product.missingPhotoUrl;
  late String? url;
  late List<String> allergens = [];
  late List<String> categories = [];

  Product.fromOpenFoodResponse(String openfoodfactsJsonResponse, String code_) {
    code = code_;

    var resp = jsonDecode(openfoodfactsJsonResponse);
    if (!resp.containsKey("products")) {
      throw ProductParseException();
    }
    List<dynamic> whereProductCodeMatches = List.castFrom(resp["products"])
        .where((e) => e["code"] == code_)
        .toList();

    if (whereProductCodeMatches.isEmpty) {
      return;
    }

    // multiple products found, guess shouldnt happen tho
    // if (whereProductCodeMatches.length > 1) {
    //   throw ProductNotFoundException();
    // }

    raw = whereProductCodeMatches[0];

    //
    name = raw.containsKey("product_name") ? raw["product_name"] : name;
    imageUrl = raw.containsKey("image_url") && !raw["image_url"].isEmpty
        ? raw["image_url"]
        : imageUrl;
    imageThumbUrl =
        raw.containsKey("image_thumb_url") && !raw["image_thumb_url"].isEmpty
            ? raw["image_thumb_url"]
            : imageThumbUrl;
    categories = raw.containsKey("categories_hierarchy")
        ? raw["categories_hierarchy"].cast<String>()
        : categories;
    allergens = raw.containsKey("allergens_hierarchy")
        ? raw["allergens_hierarchy"].cast<String>()
        : allergens;
    url = raw.containsKey("url") ? raw["url"] : url;

    allergens = allergens.map((a) => a.substring(3)).toList();

    // print(this);
  }

  Product(this.code, this.name, this.imageUrl, this.imageThumbUrl, this.url,
      this.allergens, this.categories);
}
