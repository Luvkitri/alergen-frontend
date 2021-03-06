import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/constants/route_names.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/dialog_service.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:frontend/services/notifications_service.dart';
import 'package:frontend/viewmodels/base_model.dart';

import '../locator.dart';

class StartUpViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DialogService _dialogService = locator<DialogService>();
  final NotificationService _notificationService =
      locator<NotificationService>();
  bool isUserLoggedIn = true;
  final storage = const FlutterSecureStorage();

  void handleStartUpLogic() async {
    setBusy(true);
    String? userid = await storage.read(key: 'USER_ID');
    //userid = null;
    if (userid != null) {
      await _authService.getUser(userid);
      await _notificationService.init();
      await _navigationService.popAndNavigateTo(homeViewRoute);
    } else {
      setBusy(false);
    }
  }

  Future newUser() async {
    String? userid = await _authService.getNewUserID();
    if (userid == null) {
      await _dialogService.showDialog(
          title: 'Error occured',
          description: 'Could not connect to the server');
    } else {
      await storage.write(key: 'USER_ID', value: userid);
      await _notificationService.init();
      await _navigationService.popAndNavigateTo(userInfoFormViewRoute);
      await _navigationService.popAndNavigateTo(homeViewRoute);
    }
  }
}
