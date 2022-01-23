import 'dart:math';
import 'package:frontend/locator.dart';
import 'package:frontend/models/allergy_model.dart';
import 'package:frontend/models/product_model.dart';
import 'package:frontend/services/allergies_service.dart';
import 'package:frontend/services/product_service.dart';
import 'package:frontend/viewmodels/base_model.dart';

class ProductViewModel extends BaseModel {
  final ProductService productService = locator<ProductService>();
  final AllergiesService _allergiesService = locator<AllergiesService>();
  bool alreadySaved = false;
  late Product product;

  Future<void> loadUsersProducts() async {
    await productService.getUserProducts();
  }

  Future<void> saveUserProduct(String code) async {
    await productService.saveUserProduct(code);
    alreadySaved = true;
    notifyListeners();
  }

  List<Allergy> userAllergies = [];

  Future<void> getAllergiesList() async {
    setBusy(true);
    await _allergiesService.getUserAllergiesList(getUser()!.id);
    userAllergies = _allergiesService.userAllergies;
    setBusy(false);
  }

  bool userHasAllergy(String allergy) {
    return userAllergies
        .where((element) => compareAllergyNames(element.name, allergy))
        .isNotEmpty;
  }

  bool compareAllergyNames(String s1, String s2) {
    return similarity(s1, s2) >= 0.9;
  }

  double similarity(String a, String b) {
    double _similarity;
    a = a.toUpperCase();
    b = b.toUpperCase();
    _similarity = 1 - levenshtein(a, b) / (max(a.length, b.length));
    return (_similarity);
  }

  int levenshtein(String a, String b) {
    a = a.toUpperCase();
    b = b.toUpperCase();
    int sa = a.length;
    int sb = b.length;
    int i, j, cost, min1, min2, min3;
    int levenshtein;
    List<List<int>> d =
        List.generate(sa + 1, (int i) => List.filled(sb + 1, 0));
    if (a.isEmpty) {
      levenshtein = b.length;
      return (levenshtein);
    }
    if (b.isEmpty) {
      levenshtein = a.length;
      return (levenshtein);
    }
    for (i = 0; i <= sa; i++) {
      d[i][0] = i;
    }
    for (j = 0; j <= sb; j++) {
      d[0][j] = j;
    }
    for (i = 1; i <= a.length; i++) {
      for (j = 1; j <= b.length; j++) {
        if (a[i - 1] == b[j - 1]) {
          cost = 0;
        } else {
          cost = 1;
        }
        min1 = (d[i - 1][j] + 1);
        min2 = (d[i][j - 1] + 1);
        min3 = (d[i - 1][j - 1] + cost);
        d[i][j] = min(min1, min(min2, min3));
      }
    }
    levenshtein = d[a.length][b.length];
    return (levenshtein);
  }
}
