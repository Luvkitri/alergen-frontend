import 'package:flutter/material.dart';

class NavigationService {
  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  void pop() {
    return _navigationKey.currentState!.pop();
  }
  void popWithResult(dynamic result) {
    return _navigationKey.currentState!.pop(result);
  }

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> popAndNavigateTo(String routeName, {dynamic arguments}) {
    return _navigationKey.currentState
        !.popAndPushNamed(routeName, arguments: arguments);
  }
  void popUntilHomeView(){
    _navigationKey.currentState!.popUntil((route) => route.isFirst);
  }
}
