import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
      return;
    }
    String id = _authService.user!.id;
    var user = User(id,
        birthday: selectedDate,
        email: emailController.text,
        name: nameController.text,
        phoneNumber: phoneNumberController.text,
        sex: groupValue);
    bool resp = await _authService.updateUser(user);
    if (!resp) {
      await _dialogService.showDialog(title: 'Error occured');
      return;
    }
    await _navigationService.popAndNavigateTo(homeViewRoute);
  }

  Future deleteUser() async {
    if (_authService.user == null) {
      await _dialogService.showDialog(title: 'Error occured');
      return;
    }
    var confirmed = await _dialogService.showConfirmationDialog(
        title: 'Delete account?',
        description: 'Are you sure to delete your account?');
    if (!confirmed.confirmed) {
      return;
    }
    var resp = await _authService.deleteUser();
    if (resp == false) {
      await _dialogService.showDialog(title: 'Error occured');
      return;
    }
    const storage = FlutterSecureStorage();
    await storage.delete(key: "USER_ID");
    _navigationService.popUntilHomeView();
    _navigationService.pop();
    _navigationService.navigateTo(startUpViewRoute);
  }

  void setUsersSex(String? value) {
    groupValue = value ?? '';
    notifyListeners();
  }

  void showBirthdayPicker(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      cancelText: 'Cancel',
      helpText: 'Pick date',

      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    selectedDate = picked ?? selectedDate;
    notifyListeners();
  }
}
