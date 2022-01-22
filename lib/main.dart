import 'package:flutter/material.dart';
import 'package:frontend/services/dialog_service.dart';
import 'package:frontend/services/navigation_service.dart';
import 'package:frontend/ui/router.dart';
import 'package:frontend/ui/shared/app_colors.dart';
import 'package:frontend/ui/views/start_up_view.dart';

import 'locator.dart';
import 'managers/dialog_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fish Stats',
      color: primaryColor,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
            textScaleFactor: 1.0), //tu pomyśleć czy może zostać ale pewnie nie
        child: Navigator(
          key: locator<DialogService>().dialogNavigationKey,
          onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => DialogManager(child: child!)),
        ),
      ),
      navigatorKey: locator<NavigationService>().navigationKey,
      theme: ThemeData(
        primaryColor: primaryColor,
        primarySwatch: Colors.purple,
        backgroundColor: backgroundColor,
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Open Sans',
              decoration: TextDecoration.none,
            ),
      ),
      home: const StartUpView(),
      onGenerateRoute: generateRoute,
    );
  }
}
