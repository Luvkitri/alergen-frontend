import 'package:flutter/material.dart';
import 'package:frontend/constants/route_names.dart';
import 'package:frontend/ui/views/example_view.dart';
import 'package:frontend/ui/views/home_view.dart';
import 'package:frontend/ui/views/product_view.dart';
import 'package:frontend/ui/views/scanner_view.dart';

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
    case productRoute:
      return _getPageRoute(settings.name!, const ProductView(),
          arguments: settings.arguments);
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
