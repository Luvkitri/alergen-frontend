import 'package:frontend/constants/route_names.dart';
import 'package:frontend/locator.dart';
import 'package:frontend/services/connetion_test_service.dart';
import 'package:frontend/services/navigation_service.dart';

import 'base_model.dart';

class HomeViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final ConnectionTestService _connectionTestService =
      locator<ConnectionTestService>();
  List<int> someList = [];

  Future fetchSomeList() async {
    setBusy(true);
    await Future.delayed(Duration(seconds: 3));
    for (int i = 0; i < 10; i++) {
      someList.add(i);
    }
    var resp = await _connectionTestService.testConnectionToTheServer();
    print(resp);
    setBusy(false);
  }

  Future fetchMoreSomeList() async {
    await fetchSomeList();
  }

  void navigateToExample() async {
    await _navigationService.navigateTo(ExampleRoute);
  }

  void navigateToScanner() async {
    await _navigationService.navigateTo(ScannerRoute);
  }
}
