import 'package:flutter/material.dart';
import 'package:frontend/constants/route_names.dart';
import 'package:frontend/ui/views/example_view.dart';
import 'package:frontend/ui/views/home_view.dart';
import 'package:frontend/ui/views/scanner_view.dart';
import 'package:frontend/ui/views/user_info_form_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case homeViewRoute:
      return _getPageRoute(
        settings.name!,
        const HomeView(),
      );
    case exampleRoute:
      return _getPageRoute(
        settings.name!,
        const ExampleView(),
      );
    case scannerRoute:
      return _getPageRoute(
        settings.name!,
        const ScannerView(),
      );
    case userInfoFormViewRoute:
      return _getPageRoute(
        settings.name!,
        const UserInfoFormView(),
      );
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}

PageRoute _getPageRoute(String routeName, Widget viewToShow) {
  return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow);
}
