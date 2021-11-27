import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:frontend/constants/route_names.dart';
import 'package:frontend/models/product_model.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:frontend/viewmodels/base_model.dart';
import 'package:frontend/models/scanner_model.dart';
import 'package:frontend/services/openfoodfacts_service.dart';
import 'package:frontend/locator.dart';
import 'dart:math';

class ScannerViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final OpenfoodfactsService _openfoodfactsService =
      locator<OpenfoodfactsService>();

  // example codes for quick tests
  static List<String> sampleCodes = [
    '3017620422003', // nutella
    '8008714002176', // bbq chips
    '5900311003705', // ??
    '20026752', // piri piri
    '8715700420585', // heinz ketchup
    '5907069000017', // sugar
    '8711000525722', // jacobs coffee
    'aaaaaaa3342342', // wrong code
    '8711000525723' // mising code
  ];

  Product getLastScannedProduct() {
    return ScannerResults.scannedProducts.last;
  }

  List<Product> getScannedProducts() {
    return ScannerResults.scannedProducts;
  }

  void removeScannedProduct(Product p) {
    ScannerResults.scannedProducts.remove(p);
    sampleCodes.add(p.code);
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

  Future addTestProduct() async {
    if (sampleCodes.isNotEmpty) {
      setBusy(true);
      String code = sampleCodes[Random().nextInt(sampleCodes.length)];
      Product p = await addUniqueProductFromCode(code);
      for (int i = 0; i < 30; i++) {
        p.allergens.add('random allergen just to fill list $i');
      }
      sampleCodes.remove(code);
      setBusy(false);
    }
  }

  Future scanCode() async {
    String code = await FlutterBarcodeScanner.scanBarcode(
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
