import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'product_model.dart';

class ScannerParameters {
  static const scannerColor = "#ff0000";
  static const scannerCancelButtonText = "Cancel";
  static const scannerShowFlashIcon = true;
  static const scannerMode = ScanMode.BARCODE;
}

class ScannerResults {
  static List<Product> scannedProducts = [];
}
