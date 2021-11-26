import 'package:flutter/material.dart';
import 'package:frontend/models/product_model.dart';
import 'package:frontend/ui/shared/ui_helpers.dart';
import 'package:frontend/ui/widgets/busy_indicator.dart';
import 'package:frontend/viewmodels/scanner_view_model.dart';
import 'package:stacked/stacked.dart';

class ScannerView extends StatelessWidget {
  const ScannerView({Key? key}) : super(key: key);

  // example codes for quick tests
  static List<String> initialCodes = [
    '3017620422003', // nutella
    '8008714002176', // bbq chips
    '5900311003705', // ??
    '20026752', // piri piri
    //'8715700420585', // heinz ketchup
    '5907069000017', // sugar
    '8711000525722', // jacobs coffee
    'aaaaaaa3342342', // wrong code
    '8711000525723' // mising code
  ];

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ScannerViewModel>.reactive(
      viewModelBuilder: () => ScannerViewModel(),
      onModelReady: (model) =>
          {initialCodes.forEach(model.addUniqueProductFromCode)},
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Scanner View"),
        ),
        body: model.busy
            ? const BusyIndicator()
            : ListView.builder(
                itemBuilder: (context, index) =>
                    buildProductList(context, index, model),
                itemCount: model.getScannedProducts().length,
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: model.scanCode,
          child: const Icon(Icons.qr_code_scanner),
          backgroundColor: Colors.green,
        ),
      ),
    );
  }

  Widget buildProductList(
      BuildContext context, int index, ScannerViewModel model) {
    Product p = model.getScannedProducts()[index];
    return InkWell(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(p.imageUrl ?? Product.missingPhotoUrl,
                fit: BoxFit.cover, width: 50, height: 50),
            Text(model.getScannedProducts()[index].name),
            horizontalSpaceSmall,
            ElevatedButton(
              onPressed: () => {
                model.removeScannedProduct(model.getScannedProducts()[index])
              },
              child: const Icon(Icons.delete),
            ),
          ]),
      onTap: () => {model.showProductInfo(model.getScannedProducts()[index])},
    );
  }
}
