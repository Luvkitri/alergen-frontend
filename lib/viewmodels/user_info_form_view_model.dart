import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants/route_names.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/dialog_service.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:frontend/viewmodels/base_model.dart';

import '../locator.dart';

class UserInfoFromViewModel extends BaseModel {
  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  String groupValue = 'X';
  DateTime? selectedDate;

  void init() {
    User user = _authService.user ?? User('ERROR');
    print(user.id);
    nameController.text = user.name ?? '';
    emailController.text = user.email ?? '';
    phoneNumberController.text = user.phoneNumber ?? '';
    groupValue = user.sex ?? 'X';
    selectedDate = user.birthday;
    notifyListeners();
  }

  Future save() async {
    if (_authService.user == null) {
      await _dialogService.showDialog(title: 'Error occured');
      //return;
    }
    String id = 'ERROR'; //_authService.user!.id;
    _authService.user = User(id,
        birthday: selectedDate,
        email: emailController.text,
        name: nameController.text,
        phoneNumber: phoneNumberController.text,
        sex: groupValue);
    await _navigationService.popAndNavigateTo(homeViewRoute);
  }

  void setUsersSex(String? value) {
    groupValue = value ?? '';
    notifyListeners();
  }

  void showBirthdayPicker(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      cancelText: 'Anuluj',
      helpText: 'Wybierz datę',

      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    selectedDate = picked;
    notifyListeners();
  }
}
