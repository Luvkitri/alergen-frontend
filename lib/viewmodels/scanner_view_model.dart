import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:frontend/viewmodels/base_model.dart';
import 'package:frontend/models/scanner_model.dart';
import 'package:frontend/services/openfoodfacts_service.dart';
import 'package:frontend/locator.dart';

class ScannerViewModel extends BaseModel {
  final OpenfoodfactsService _openfoodfactsService =
      locator<OpenfoodfactsService>();

  String getLastScannedCode() {
    return ScannerResults.codes.isNotEmpty ? ScannerResults.codes.last : "";
  }

  List<String> getScannedCodes() {
    return ScannerResults.codes;
  }

  void forgetCode(String code) {
    ScannerResults.codes.remove(code);
    notifyListeners();
  }

  Future scanCode() async {
    setBusy(true);
    String code = await FlutterBarcodeScanner.scanBarcode(
        ScannerParameters.scannerColor,
        ScannerParameters.scannerCancelButtonText,
        ScannerParameters.scannerShowFlashIcon,
        ScannerParameters.scannerMode);
    setBusy(false);
    if (int.parse(code) != -1) {
      ScannerResults.codes.add(code);
      if (await checkApi()) {
        // TODO: search for barcode in foods api
      }
    }
  }

  Future<bool> checkApi() async {
    return await _openfoodfactsService.testConnectionToTheServer();
  }
}
