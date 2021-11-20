import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScannerParameters {
  static const scannerColor = "#ff0000";
  static const scannerCancelButtonText = "Cancel";
  static const scannerShowFlashIcon = true;
  static const scannerMode = ScanMode.BARCODE;
}

class ScannerResults {
  static List<String> codes = [
    '3017620422003',
    '8008714002176'
  ]; // two example codes for quick tests
}
