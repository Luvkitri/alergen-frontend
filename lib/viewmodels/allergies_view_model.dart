import 'package:frontend/constants/route_names.dart';
import 'package:frontend/locator.dart';
import 'package:frontend/models/allergy_model.dart';
import 'package:frontend/services/allergies_service.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:frontend/viewmodels/base_model.dart';

class AllergiesViewModel extends BaseModel {
  final AllergiesService _allergiesService = locator<AllergiesService>();
  final NavigationService _navigationService = locator<NavigationService>();
  List<Allergy> allergies = [];
  void getAllergiesList() async {
    setBusy(true);
    allergies = await _allergiesService.getUserAllergiesList(getUser()!.id);
    setBusy(false);
  }

  void navigateToAddAllergies() async {
    await _navigationService.navigateTo(addAllergiesViewRoute);
    allergies = await _allergiesService.getUserAllergiesList(getUser()!.id);
    notifyListeners();
  }
}
