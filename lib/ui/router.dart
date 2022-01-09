import 'package:flutter/material.dart';
import 'package:frontend/constants/route_names.dart';
import 'package:frontend/ui/views/add_allergies_view.dart';
import 'package:frontend/ui/views/allergies_view.dart';
import 'package:frontend/ui/views/cross_allergies_view.dart';
import 'package:frontend/ui/views/example_view.dart';
import 'package:frontend/ui/views/forecast_view.dart';
import 'package:frontend/ui/views/home_view.dart';
import 'package:frontend/ui/views/product_view.dart';
import 'package:frontend/ui/views/scanner_view.dart';
import 'package:frontend/ui/views/start_up_view.dart';
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
    case startUpViewRoute:
      return _getPageRoute(
        settings.name!,
        const StartUpView(),
      );
    case forecastRoute:
      return _getPageRoute(
        settings.name!,
        const ForecastView(),
      );
    case allergiesViewRoute:
      return _getPageRoute(
        settings.name!,
        const AllergiesView(),
      );
    case addAllergiesViewRoute:
      return _getPageRoute(
        settings.name!,
        const AddAllergiesView(),
      );
    case crossAllergiesViewRoute:
      List<int> ids = settings.arguments as List<int>? ?? [];
      return _getPageRoute(
        settings.name!,
        CrossAllergiesView(selectedAllergies: ids),
      );
    case productRoute:
      return _getPageRoute(
        settings.name!,
        const ProductView(),
        arguments: settings.arguments,
      );
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}

PageRoute _getPageRoute(String routeName, Widget viewToShow,
    {dynamic arguments}) {
  return MaterialPageRoute(
      settings: RouteSettings(name: routeName, arguments: arguments),
      builder: (_) => viewToShow);
}
