import 'package:frontend/locator.dart';
import 'package:frontend/models/allergy_model.dart';
import 'package:frontend/services/allergies_service.dart';
import 'package:frontend/services/dialog_service.dart';
import 'package:frontend/services/navigation_service.dart';
import 'base_model.dart';

class CrossAllergiesViewModel extends BaseModel {
  final AllergiesService _allergiesService = locator<AllergiesService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Map<int, List<Allergy>> crossAllergies = {};
  var userAllergies = [];

  List<int> selectedids = [];
  List<bool> selectedCheckbox = List.filled(100, false);
  void getCrossAllergiesList(List<int> userAllergies) async{
    this.userAllergies = userAllergies;
    if (userAllergies.isEmpty) {
      _navigationService.popWithResult([]);
      return;
    }
    var resp = _allergiesService.getCrossAllergiesFromIdList(userAllergies);
    //TODO: poprawny resp
    crossAllergies.addAll(
      {
        3: [
          getAllergyFromId(1),
          getAllergyFromId(2),
          getAllergyFromId(10),
        ],
        10: [
          getAllergyFromId(11),
          getAllergyFromId(14),
        ]
      },
    );
    notifyListeners();
  }

  Allergy getAllergyFromId(int id) {
    return _allergiesService.allergies.singleWhere(
      (element) => element.id == id,
    );
  }

  void selectCrossAllergy(bool? value, int id) {
    if (value == true) {
      selectedCheckbox[id] = true;
    } else {
      selectedCheckbox[id] = false;
    }
    notifyListeners();
  }

  void save() {
    List<int> out = [];
    for (int i = 0; i < selectedCheckbox.length; i++) {
      if (selectedCheckbox[i]) {
        out.add(i);
      }
    }
    _navigationService.popWithResult(out.toSet().toList());
  }

  void showHelp() async{
    await _dialogService.showDialog(
      title: 'Cross-Allergies',
      description:
          'These allergies may also have an effect on you, because of cross-allergy dependecy',
    );
  }

  Future<bool> onWillPop() {
    save();
    return Future.value(true);
  }
}
