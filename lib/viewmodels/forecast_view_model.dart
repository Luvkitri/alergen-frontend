import 'dart:ffi';

import 'package:frontend/locator.dart';
import 'package:frontend/models/geo_model.dart';
import 'package:frontend/services/forecast_service.dart';
import 'package:frontend/services/geo_service.dart';
import 'package:frontend/viewmodels/base_model.dart';

class ForecastViewModel extends BaseModel {
  final ForecastService _forecastService = locator<ForecastService>();
  final GeoService _geoService = locator<GeoService>();

  PositionItem? position;

  Future<String?> getLocation() async {
    await _geoService.getCurrentPosition();
    position = _geoService.getLastPosition();
    notifyListeners();
  }
}
