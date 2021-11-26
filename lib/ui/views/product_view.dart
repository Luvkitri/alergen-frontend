import 'package:flutter/material.dart';
import 'package:frontend/models/product_model.dart';
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
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;

    return ViewModelBuilder<ProductViewModel>.reactive(
      viewModelBuilder: () => ProductViewModel(),
      onModelReady: (model) {},
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Product view"),
        ),
        body: model.busy
            ? const BusyIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(product.imageUrl ?? missingPhotoUrl,
                      fit: BoxFit.cover, height: 400),
                  Text(product.name, style: titleStyleHugeB),
                  product.allergens.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                          itemBuilder: (context, index) =>
                              buildAllergenList(context, index, model, product),
                          itemCount: product.allergens.length,
                        ))
                      : const Text("No allergens"),
                  TextButton(
                      style: const ButtonStyle(),
                      child: const Text(
                        'Placeholder button.',
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.bold),
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
                ],
              ),
      ),
    );
  }

  Widget buildAllergenList(
      BuildContext context, int index, ProductViewModel model, Product p) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('allergens[$index]: ${p.allergens[index]}'),
        ElevatedButton(
          onPressed: () => {},
          child: const Text('placeholder'),
        ),
      ],
    );
  }
}
