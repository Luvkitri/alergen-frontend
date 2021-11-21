import 'package:flutter/material.dart';
import 'package:frontend/viewmodels/product_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:frontend/ui/widgets/busy_indicator.dart';
import 'package:frontend/ui/shared/app_colors.dart';
import 'package:frontend/ui/shared/shared_styles.dart';
import 'package:frontend/ui/shared/ui_helpers.dart';

class ProductView extends StatelessWidget {
  const ProductView({Key? key}) : super(key: key);

  static const String missingPhotoUrl =
      'https://upload.wikimedia.org/wikipedia/commons/b/b1/Missing-image-232x150.png';

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductViewModel>.reactive(
      viewModelBuilder: () => ProductViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Product view"),
        ),
        body: model.busy
            ? const BusyIndicator()
            : model.errorMsg != null
                ? Text(model.errorMsg!)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.network(
                          model.p!.raw.containsKey("image_url")
                              ? model.p!.raw["image_url"]
                              : missingPhotoUrl,
                          fit: BoxFit.fill,
                          height: 400),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(model.p!.raw["product_name"],
                                    style: titleStyleHugeB),
                                Text(model.p!.raw["allergens"]),
                                TextButton(
                                    style: const ButtonStyle(),
                                    child: const Text(
                                      'Placeholder button.',
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () => {}),
                                TextButton(
                                    child: const Text(
                                      'Placeholder button2.',
                                      style: TextStyle(
                                          color: secondaryColor,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    onPressed: () => {}),
                              ])),
                    ],
                  ),
      ),
    );
  }
}
