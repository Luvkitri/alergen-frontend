import 'package:frontend/models/product_model.dart';
import 'package:frontend/services/openfoodfacts_service.dart';
import 'package:frontend/viewmodels/base_model.dart';
import 'package:frontend/locator.dart';

class ProductViewModel extends BaseModel {
  final OpenfoodfactsService _openfoodfactsService =
      locator<OpenfoodfactsService>();

  Product? p;
  String? errorMsg;

  Future<void> loadProductInfo() async {
    setBusy(true);
    try {
      p = await _openfoodfactsService.findProduct();
      errorMsg = null;
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
