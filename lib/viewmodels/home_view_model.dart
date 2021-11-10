import 'package:frontend/constants/route_names.dart';
import 'package:frontend/locator.dart';
import 'package:frontend/services/navigation_service.dart';

import 'base_model.dart';

class HomeViewModel extends BaseModel {

  final NavigationService _navigationService = locator<NavigationService>();

  List<int> someList = [];

  Future fetchSomeList() async {
    setBusy(true);
    await Future.delayed(Duration(seconds: 3));
    for (int i = 0; i < 10; i++) {
      someList.add(i);
    }
    setBusy(false);
  }

  Future fetchMoreSomeList() async {
    await fetchSomeList();
  }
  void navigateToExample() async{
    await _navigationService.navigateTo(ExampleRoute);
  }
}
