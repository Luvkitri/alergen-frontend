import 'package:flutter/material.dart';
import 'package:frontend/viewmodels/product_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:frontend/ui/widgets/busy_indicator.dart';

class ProductView extends StatelessWidget {
  const ProductView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductViewModel>.reactive(
      viewModelBuilder: () => ProductViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text("Product view"),
        ),
        // ignore: avoid_unnecessary_containers
        body: Container(
          child: model.busy
              ? const BusyIndicator()
              : model.errorMsg != null
                  ? Text(model.errorMsg!)
                  : Column(
                      children: [
                        model.p!.raw.containsKey("image_url")
                            ? Image.network(model.p!.raw["image_url"])
                            : Image.network(
                                'https://upload.wikimedia.org/wikipedia/commons/b/b1/Missing-image-232x150.png'),
                        Text(model.p!.raw["product_name"]),
                        Text(model.p!.raw["allergens"]),
                      ],
                    ),
        ),
      ),
    );
  }
}
