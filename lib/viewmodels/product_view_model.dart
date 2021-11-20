import 'package:frontend/models/product_model.dart';
import 'package:frontend/services/openfoodfacts_service.dart';
import 'package:frontend/viewmodels/base_model.dart';
import 'package:frontend/locator.dart';

class ProductViewModel extends BaseModel {
  final OpenfoodfactsService _openfoodfactsService =
      locator<OpenfoodfactsService>();

  ProductViewModel() {
    setBusy(true);
    loadProductInfo();
  }

  Product? p;
  String? errorMsg;

  Future<void> loadProductInfo() async {
    errorMsg = null;
    try {
      p = await _openfoodfactsService.findProduct();
    } on ProductNotFoundException {
      errorMsg = "Product not found";
    } on ProductParseException {
      errorMsg = "Response parsing error";
    } on Exception {
      errorMsg = "Exception";
    } finally {
      setBusy(false);
    }
  }
}
