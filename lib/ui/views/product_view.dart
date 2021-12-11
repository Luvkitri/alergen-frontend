import 'package:flutter/material.dart';
import 'package:frontend/models/product_model.dart';
import 'package:frontend/viewmodels/product_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:frontend/ui/widgets/busy_indicator.dart';
import 'package:frontend/ui/shared/app_colors.dart';
import 'package:frontend/ui/shared/shared_styles.dart';

class ProductView extends StatelessWidget {
  const ProductView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;

    return ViewModelBuilder<ProductViewModel>.reactive(
      viewModelBuilder: () => ProductViewModel(),
      onModelReady: (model) {
        model.product = product;
        model.getAllergiesList();
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Product"),
        ),
        body: model.busy
            ? const BusyIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.network(product.imageUrl ?? Product.missingPhotoUrl,
                      fit: BoxFit.cover, height: 150),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.name, style: titleStyleHugeB),
                            const Text('Allergens:')
                          ])),
                  product.allergens.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                          itemExtent: 60.0,
                          itemBuilder: (context, index) =>
                              buildAllergenList(context, index, model, product),
                          itemCount: product.allergens.length,
                        ))
                      : const Text("Haven't found any allergens"),
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
                      onPressed: () => {})
                ],
              ),
      ),
    );
  }

  Widget buildAllergenList(
      BuildContext context, int index, ProductViewModel model, Product p) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(p.allergens[index])),
            Text("${model.userHasAllergy(p.allergens[index])}"),
            ElevatedButton(
              onPressed: () => {},
              child: const Text('placeholder'),
            ),
          ],
        ));
  }
}
