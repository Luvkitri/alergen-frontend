import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:frontend/constants/route_names.dart';
import 'package:frontend/models/product_model.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:frontend/viewmodels/base_model.dart';
import 'package:frontend/models/scanner_model.dart';
import 'package:frontend/services/openfoodfacts_service.dart';
import 'package:frontend/locator.dart';

class ScannerViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final OpenfoodfactsService _openfoodfactsService =
      locator<OpenfoodfactsService>();

  Product getLastScannedProduct() {
    return ScannerResults.scannedProducts.last;
  }

  List<Product> getScannedProducts() {
    return ScannerResults.scannedProducts;
  }

  void removeScannedProduct(Product p) {
    ScannerResults.scannedProducts.remove(p);
    notifyListeners();
  }

  Future<void> addProductFromCode(String code) async {
    Product p = await _openfoodfactsService.findProduct(code);
    ScannerResults.scannedProducts.insert(0, p);
    notifyListeners();
  }

  Future scanCode() async {
    String code;

    // ignore: dead_code
    if (false) {
      code = await FlutterBarcodeScanner.scanBarcode(
          ScannerParameters.scannerColor,
          ScannerParameters.scannerCancelButtonText,
          ScannerParameters.scannerShowFlashIcon,
          ScannerParameters.scannerMode);
    } else {
      // static code just for testing without actually scanning
      code = '8715700420585';
    }
    print(code);
    addProductFromCode(code);
  }

  Future<bool> checkApi() async {
    return await _openfoodfactsService.testConnectionToTheServer();
  }

  Future<void> showProductInfo(Product p) async {
    // TODO: pass argument to opened view (somehow)
    OpenfoodfactsService.currentViewedProduct = p;

    await _navigationService.navigateTo(productRoute, arguments: p);
  }
}
