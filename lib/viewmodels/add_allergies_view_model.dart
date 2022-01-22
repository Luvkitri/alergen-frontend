import 'package:flutter/cupertino.dart';
import 'package:frontend/constants/route_names.dart';
import 'package:frontend/models/allergy_model.dart';
import 'package:frontend/services/allergies_service.dart';
import 'package:frontend/services/dialog_service.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:frontend/viewmodels/base_model.dart';

import '../locator.dart';

class AddAllergiesViewModel extends BaseModel {
  final AllergiesService _allergiesService = locator<AllergiesService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  List<Allergy> allergies = [];
  List<Allergy> allAllergies = [];
  List<bool> allergiesSelected = [];

  var filterController = TextEditingController();

  void getAllergiesList() async {
    setBusy(true);
    allergies = await _allergiesService.getAllergiesList();
    final result = allergies.fold<Allergy>(allergies.first, (max, element) {
          if (max.id < element.id) {
            return element;
          }
          return max;
        }).id +
        1;
    allergiesSelected = List.filled(result, false);
    List userAllergies = _allergiesService.userAllergies;
    for (int i = 0; i < allergies.length; i++) {
      if (userAllergies.contains(allergies[i])) {
        allergiesSelected[allergies[i].id] = true;
      }
    }
    sortAllergiesBySelection();
    allAllergies = allergies;
    setBusy(false);
  }

  void sortAllergiesBySelection(){
    allergies.sort((a, b) {
      if(allergiesSelected[b.id]) {
        return 1;
      }
      return -1;
    });
  }

  void addAllergyToList(int index, bool? i) {
    allergiesSelected[index] = i!;
    notifyListeners();
  }

  Future saveUsersAllergies() async {
    setBusy(true);
    List<int> allergiesSelectedId = [];
    for (int i = 0; i < allergiesSelected.length; i++) {
      if (allergiesSelected[i]) {
        allergiesSelectedId.add(i);
      }
    }
    List<int> userAllergies = List.from(
      _allergiesService.userAllergies.map((a) => a.id),
    );
    if (allergiesSelectedId.isNotEmpty) {
      List<int> respAll = await _navigationService.navigateTo(
              crossAllergiesViewRoute,
              arguments: allergiesSelectedId) as List<int>? ??
          [];
      allergiesSelectedId.addAll(respAll);
    }
    var resp2 = true;
    if (userAllergies.isNotEmpty) {
      resp2 = await _allergiesService.deleteUsersAllergies(
          getUser()!.id, userAllergies);
    }
    var resp = await _allergiesService.saveUsersAllergies(
        getUser()!.id, allergiesSelectedId.toSet().toList());
    setBusy(false);
    if (!resp || !resp2) {
      await _dialogService.showDialog(
          title: 'Error',
          description: 'Error occured while adding your allergies');
    } else {
      _navigationService.pop();
    }
  }

  void clearSearch() {
    filterController.clear();
    allergies = allAllergies;
    sortAllergiesBySelection();
    notifyListeners();
  }

  void filterAllergies(String input) {
    allergies = [];
    for (var element in allAllergies) {
      if (element.name.toLowerCase().contains(input)) {
        allergies.add(element);
      }
    }
    if(input == ''){
      allergies = allAllergies;
    }
    sortAllergiesBySelection();
    notifyListeners();
  }
}
