import 'package:frontend/locator.dart';
import 'package:frontend/models/forecast_model.dart';
import 'package:frontend/models/geo_model.dart';
import 'package:frontend/services/forecast_service.dart';
import 'package:frontend/services/geo_service.dart';
import 'package:frontend/viewmodels/base_model.dart';

class ForecastViewModel extends BaseModel {
  final ForecastService _forecastService = locator<ForecastService>();
  final GeoService _geoService = locator<GeoService>();

  PositionItem? position;

  ForecastItem? todaysForecast;

  Future<String?> getLocation() async {
    setBusy(true);
    await _getLocation();
    setBusy(false);
  }

  Future<String?> _getLocation() async {
    await _geoService.getCurrentPosition();
    position = _geoService.getLastPosition();
  }

  Future<void> getForecast() async {
    setBusy(true);
    if (position == null) {
      await _getLocation();
    }
    todaysForecast =
        await _forecastService.getForecastForDate(DateTime.now(), position!);
    setBusy(false);
  }
}
