import 'package:frontend/constants/route_names.dart';
import 'package:frontend/locator.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:frontend/services/notifications_service.dart';

import 'base_model.dart';

class HomeViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final NotificationService _notificationService = locator<NotificationService>();
  List<int> someList = [];

  Future fetchSomeList() async {
    setBusy(true);
    for (int i = 0; i < 10; i++) {
      someList.add(i);
    }
    setBusy(false);
  }

  Future fetchMoreSomeList() async {
    await fetchSomeList();
  }

  void navigateToExample() async {
    await _navigationService.navigateTo(exampleRoute);
  }

  void navigateToScanner() async {
    await _navigationService.navigateTo(scannerRoute);
  }

  void navigateToUserInfoForm() async {
    await _navigationService.navigateTo(userInfoFormViewRoute);

  }

  void navigateToForecast() async {
    await _navigationService.navigateTo(forecastRoute);
  }

  void navigateToAllergies() async {
    await _navigationService.navigateTo(allergiesViewRoute);
  }

  void showNotification() async {
    await _notificationService.showNotification();
  }
}
