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

  Future<Product> addUniqueProductFromCode(String code) async {
    if (!ScannerResults.scannedProducts.any((p) => p.code == code)) {
      return addProductFromCode(code);
    } else {
      return ScannerResults.scannedProducts.firstWhere((p) => p.code == code);
    }
  }

  Future<Product> addProductFromCode(String code) async {
    Product p = await _openfoodfactsService.findProduct(code);
    ScannerResults.scannedProducts.insert(0, p);
    notifyListeners();
    return p;
  }

  Future scanCode() async {
    String code;

    code = await FlutterBarcodeScanner.scanBarcode(
        ScannerParameters.scannerColor,
        ScannerParameters.scannerCancelButtonText,
        ScannerParameters.scannerShowFlashIcon,
        ScannerParameters.scannerMode);
    Product p = await addUniqueProductFromCode(code);
    showProductInfo(p);
  }

  Future<bool> checkApi() async {
    return await _openfoodfactsService.testConnectionToTheServer();
  }

  Future<void> showProductInfo(Product p) async {
    await _navigationService.navigateTo(productRoute, arguments: p);
  }
}
