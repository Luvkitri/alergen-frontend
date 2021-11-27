import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/constants/route_names.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/dialog_service.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:frontend/viewmodels/base_model.dart';

import '../locator.dart';

class StartUpViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DialogService _dialogService = locator<DialogService>();
  bool isUserLoggedIn = true;
  final storage = const FlutterSecureStorage();
  void handleStartUpLogic() async {
    String? userid = await storage.read(key: 'USER_ID');
    userid = null;
    if (userid == null) {
      //userid = await _authService.getNewUserID();
      userid = "";
      if (userid == null) {
        await _dialogService.showDialog(
            title: 'Wystąpił błąd',
            description: 'Nie udało się połączyć z serwerem');
      } else {
        await storage.write(key: 'USER_ID', value: userid);
        await _navigationService.popAndNavigateTo(userInfoFormViewRoute);
        await _navigationService.popAndNavigateTo(homeViewRoute);
      }
    } else {
      //await _authService.getUser(userid);
      await _authService.getUser(userid);
      await _navigationService.popAndNavigateTo(homeViewRoute);
    }
  }
}
