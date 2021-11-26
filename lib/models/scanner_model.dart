import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'product_model.dart';

class ScannerParameters {
  static const scannerColor = "#ff0000";
  static const scannerCancelButtonText = "Cancel";
  static const scannerShowFlashIcon = true;
  static const scannerMode = ScanMode.BARCODE;
}

class ScannerResults {
  // to be depricated
  // static List<String> codes = [
  //   '3017620422003', // nutella
  //   '8008714002176', // bbq chips
  //   '5900311003705', // ??
  //   '20026752', // piri piri
  //   //'8715700420585', // heinz ketchup
  //   '5907069000017', // sugar
  //   '8711000525722', // jacobs coffee
  //   'aaaaaaa3342342', // wrong code
  //   '8711000525723' // mising code
  // ]; // example codes for quick tests

  static List<Product> scannedProducts = [];
}
