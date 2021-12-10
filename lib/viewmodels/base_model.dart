import 'package:flutter/widgets.dart';
import 'package:frontend/locator.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/auth_service.dart';

class BaseModel extends ChangeNotifier {
  final AuthService _authService = locator<AuthService>();
  bool _busy = false;
  bool get busy => _busy;
  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

  User? getUser(){
    return _authService.user;
  }
}
