import 'package:flutter/material.dart';
import 'package:frontend/ui/shared/ui_helpers.dart';
import 'package:frontend/ui/widgets/busy_indicator.dart';
import 'package:frontend/viewmodels/scanner_view_model.dart';
import 'package:stacked/stacked.dart';

class ScannerView extends StatelessWidget {
  const ScannerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ScannerViewModel>.reactive(
      viewModelBuilder: () => ScannerViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Scanner View"),
        ),
        body: model.busy
            ? const BusyIndicator()
            : ListView.builder(
                itemBuilder: (context, index) {
                  //return buildList(context, index, model);
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Code: ${model.getScannedProducts()[index].code}'),
                        horizontalSpaceSmall,
                        ElevatedButton(
                          onPressed: () => {
                            model.showProductInfo(
                                model.getScannedProducts()[index])
                          },
                          child: const Text('Info'),
                        ),
                        ElevatedButton(
                          onPressed: () => {
                            model.removeScannedProduct(
                                model.getScannedProducts()[index])
                          },
                          child: const Icon(Icons.remove),
                        ),
                      ]);
                },
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
}
