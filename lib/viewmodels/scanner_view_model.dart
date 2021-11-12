import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:frontend/viewmodels/base_model.dart';
import 'package:frontend/models/scanner_model.dart';

class ScannerViewModel extends BaseModel {
  String getLastScannedCode() {
    return ScannerResults.codes.isNotEmpty ? ScannerResults.codes.last : "";
  }

  List<String> getScannedCodes() {
    return ScannerResults.codes;
  }

  void forgetCode(String code) {
    setBusy(true);
    ScannerResults.codes.remove(code);
    setBusy(false);
  }

  Future<String?> scanCode() async {
    setBusy(true);
    String code = await FlutterBarcodeScanner.scanBarcode(
        ScannerParameters.scannerColor,
        ScannerParameters.scannerCancelButtonText,
        ScannerParameters.scannerShowFlashIcon,
        ScannerParameters.scannerMode);
    setBusy(false);
    if (int.parse(code) != -1) {
      ScannerResults.codes.add(code);
      return code;
    } else {
      return null;
    }
  }
}
