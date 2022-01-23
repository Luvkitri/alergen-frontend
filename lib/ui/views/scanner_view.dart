import 'package:flutter/material.dart';
import 'package:frontend/models/product_model.dart';
import 'package:frontend/ui/widgets/busy_indicator.dart';
import 'package:frontend/viewmodels/scanner_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:frontend/ui/shared/app_colors.dart';

class ScannerView extends StatelessWidget {
  const ScannerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ScannerViewModel>.reactive(
      viewModelBuilder: () => ScannerViewModel(),
      onModelReady: (model) => {},
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Product scanner"),
          actions: [
            IconButton(
                onPressed: model.addTestProduct,
                icon: const Icon(Icons.add_box))
          ],
        ),
        body: model.busy
            ? const BusyIndicator()
            : ListView.builder(
                itemExtent: 100.0,
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
    return Padding(
        padding: const EdgeInsets.all(8),
        child: InkWell(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                    aspectRatio: 1.0,
                    child: Image.network(p.imageUrl ?? Product.missingPhotoUrl,
                        fit: BoxFit.cover)),
                Expanded(
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                            '${model.getScannedProducts()[index].name} (${model.getScannedProducts()[index].allergens.length.toString()})'),
                      )),
                ),
                TextButton(
                  onPressed: () => {
                    model
                        .removeScannedProduct(model.getScannedProducts()[index])
                  },
                  child: const Icon(Icons.delete),
                ),
              ]),
          onTap: () =>
              {model.showProductInfo(model.getScannedProducts()[index])},
        ));
  }
}
