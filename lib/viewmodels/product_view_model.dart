import 'package:frontend/locator.dart';
import 'package:frontend/models/allergy_model.dart';
import 'package:frontend/models/product_model.dart';
import 'package:frontend/services/allergies_service.dart';
import 'package:frontend/viewmodels/base_model.dart';

class ProductViewModel extends BaseModel {
  final AllergiesService _allergiesService = locator<AllergiesService>();

  late Product product;

  List<Allergy> userAllergies = [];

  Future<void> getAllergiesList() async {
    setBusy(true);
    await _allergiesService.getUserAllergiesList(getUser()!.id);
    userAllergies = _allergiesService.userAllergies;
    setBusy(false);
  }

  bool userHasAllergy(String allergy) {
    return userAllergies.where((element) => element.name == allergy).isNotEmpty;
  }
}
