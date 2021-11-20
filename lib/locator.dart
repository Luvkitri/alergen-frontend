
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/services/connetion_test_service.dart';
import 'package:get_it/get_it.dart';
import 'package:frontend/services/dialog_service.dart';
import 'package:frontend/services/navigation_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<NavigationService>(() => NavigationService());
  locator.registerLazySingleton<DialogService>(() => DialogService());
  locator.registerLazySingleton<ConnectionTestService>(() => ConnectionTestService());
  locator.registerLazySingleton<AuthService>(() => AuthService());
}
