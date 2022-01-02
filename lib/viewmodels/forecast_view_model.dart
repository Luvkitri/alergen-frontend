import 'package:flutter/material.dart';
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

  DateTime today = DateTime.now();

  String? selectedRegion = 'Region 2';

  //view vars
  int _selectedIndex = 0;

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  int getIndex() {
    return _selectedIndex;
  }

  Future<void> getLocation() async {
    setBusy(true);
    await _updatePosition();
    setBusy(false);
  }

  Future<void> getForecast({bool add180days = false}) async {
    setBusy(true);

    today = DateTime.now().add(Duration(days: add180days ? 180 : 0));

    await _assertPosition();
    await Future.wait({
      _getTodayForecast(),
      _getWeekForecast(),
      _getMonthForecast(),
    });
    setBusy(false);
  }

  Future<void> _getTodayForecast() async {
    todaysForecast =
        await _forecastService.getForecastForDate(today, position!);
    selectedRegion = 'Region ' + todaysForecast!.region.toString();
  }

  Future<void> _getWeekForecast() async {
    weekForecast = await _forecastService.getForecastForDateRange(
        today, today.add(const Duration(days: 7)), position!);
  }

  Future<void> _getMonthForecast() async {
    monthForecast = await _forecastService.getForecastForDateRange(
        today, today.add(const Duration(days: 30)), position!);
  }

  Future<void> _assertPosition() async {
    try {
      position = _geoService.getLastPosition();
    } catch (e) {
      position == null;
    }

    if (position == null) {
      await _updatePosition();
    }
  }

  Future<void> _updatePosition() async {
    await _geoService.getCurrentPosition();
    position = _geoService.getLastPosition();
  }

  List<DropdownMenuItem<String>> getMapRegionItems() {
    return ['Region 1', 'Region 2', 'Region 3', 'Region 4'].map(
      (val) {
        return DropdownMenuItem<String>(child: Text(val), value: val);
      },
    ).toList();
  }

  void setMapRegion(String? value) {
    selectedRegion = value;
    notifyListeners();
  }

  Widget getRegionImage() {
    switch (selectedRegion) {
      case 'Region 2':
        return Image.asset('assets/images/polskaAlergia2.png');
      case 'Region 3':
        return Image.asset('assets/images/polskaAlergia3.png');
      case 'Region 4':
        return Image.asset('assets/images/polskaAlergia4.png');
      case 'Region 1':
      default:
        return Image.asset('assets/images/polskaAlergia1.png');
    }
  }
}
