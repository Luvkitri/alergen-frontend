import 'package:flutter/material.dart';
import 'package:frontend/models/product_model.dart';
import 'package:frontend/services/product_service.dart';
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
        model.alreadySaved =
            model.productService.usersSavedProducts.contains(product.code);
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
                            Text(
                              product.name,
                              style: titleStyleHugeB,
                            ),
                            const Text('Allergens:')
                          ])),
                  product.allergens.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                          itemExtent: 60.0,
                          itemBuilder: (context, index) => _buildAllergenList(
                              context, index, model, product),
                          itemCount: product.allergens.length,
                        ))
                      : const Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 15, 0),
                          child: Text("Haven't found any allergens"),
                        ),
                  TextButton(
                    child: Text(
                      model.alreadySaved
                          ? "Product already saved"
                          : 'Save product',
                    ),
                    onPressed: model.alreadySaved
                        ? null
                        : () => {
                              model.saveUserProduct(model.product.code),
                            },
                  ),
                  // TextButton(
                  //     child: const Text(
                  //       'Placeholder button2.',
                  //       style: TextStyle(
                  //           color: secondaryColor,
                  //           fontWeight: FontWeight.normal),
                  //     ),
                  //     onPressed: () => {})
                ],
              ),
      ),
    );
  }

  Widget _buildAllergenList(
      BuildContext context, int index, ProductViewModel model, Product p) {
    bool userHasAllergy = model.userHasAllergy(p.allergens[index]);
    return Container(
        color: userHasAllergy ? Colors.redAccent[100] : null,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(p.allergens[index])),
                ElevatedButton(
                  onPressed: () => {},
                  child: const Text('placeholder'),
                ),
              ],
            )));
  }
}
