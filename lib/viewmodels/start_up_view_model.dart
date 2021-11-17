import 'package:frontend/constants/route_names.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:frontend/viewmodels/base_model.dart';

import '../locator.dart';

class StartUpViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  bool isUserLoggedIn = true;
  void handleStartUpLogic() async {
    if (isUserLoggedIn) {
      await Future.delayed(const Duration(seconds: 3));
      await _navigationService.popAndNavigateTo(homeViewRoute);
    } else {
      await _navigationService.popAndNavigateTo(loginViewRoute);
    }
  }
}
