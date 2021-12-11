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

  List<ForecastItem>? weekForecast;

  List<ForecastItem>? monthForecast;

  Future<void> getLocation() async {
    setBusy(true);
    await _updatePosition();
    setBusy(false);
  }

  Future<void> getForecast() async {
    setBusy(true);
    await assertPosition();
    Future.wait({
      getTodayForecast(),
      getWeekForecast(),
      getMonthForecast(),
    });
    setBusy(false);
  }

  Future<void> getTodayForecast() async {
    todaysForecast =
        await _forecastService.getForecastForDate(DateTime.now(), position!);
  }

  Future<void> getWeekForecast() async {
    weekForecast = await _forecastService.getForecastForDateRange(
        DateTime.now(), DateTime.now().add(const Duration(days: 7)), position!);
  }

  Future<void> getMonthForecast() async {
    monthForecast = await _forecastService.getForecastForDateRange(
        DateTime.now(),
        DateTime.now().add(const Duration(days: 30)),
        position!);
  }

  Future<void> assertPosition() async {
    if (position == null) {
      await _updatePosition();
    }
  }

  Future<void> _updatePosition() async {
    await _geoService.getCurrentPosition();
    position = _geoService.getLastPosition();
  }
}
