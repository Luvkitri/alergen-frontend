import 'package:frontend/models/product_model.dart';
import 'package:frontend/services/openfoodfacts_service.dart';
import 'package:frontend/viewmodels/base_model.dart';
import 'package:frontend/locator.dart';

class ProductViewModel extends BaseModel {
  final OpenfoodfactsService _openfoodfactsService =
      locator<OpenfoodfactsService>();

  late Product product;
}
