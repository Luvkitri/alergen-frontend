import 'dart:convert';

import 'package:frontend/models/forecast_model.dart';
import 'package:frontend/models/geo_model.dart';
import 'package:http/http.dart' as http;

class ForecastService {
  static String baseUrl = '10.0.2.2:8001';
  List<ForecastItem> forecastForRange = [];

  Future<ForecastItem?> getForecastForDate(
      DateTime date, PositionItem location) async {
    final queryParameters = {
      'now': date.toIso8601String().substring(0, 10),
      'lat': '${location.latitude}',
      'lon': '${location.longitude}'
    };

    Uri uri = Uri.http(baseUrl, '/api/getPerRegion', queryParameters);
    http.Response response = await http.get(uri, headers: {});
    try {
      Map<String, dynamic> data = jsonDecode(response.body);
      assert(data.containsKey('date'));
      assert(data.containsKey('region'));
      assert(data.containsKey('allergies'));
    } on Exception {
      return null;
    }
    return ForecastItem.fromJson(response.body);
  }

  Future<List<ForecastItem>> getForecastForDateRange(
      DateTime dateStart, DateTime dateEnd, PositionItem location) async {
    final queryParameters = {
      'date_from': dateStart.toIso8601String().substring(0, 10),
      'date_to': dateEnd.toIso8601String().substring(0, 10),
      'lat': '${location.latitude}',
      'lon': '${location.longitude}'
    };

    Uri uri = Uri.http(baseUrl, '/api/getPerRegionRange', queryParameters);
    http.Response response = await http.get(uri, headers: {});

    List<ForecastItem> forecasts = [];
    try {
      List<dynamic> data = jsonDecode(response.body);

      for (var singleDayForecast in data) {
        assert(singleDayForecast.containsKey('date'));
        assert(singleDayForecast.containsKey('region'));
        assert(singleDayForecast.containsKey('allergies'));
      }
      for (var singleDayForecast in data) {
        forecasts.add(ForecastItem.fromJson(jsonEncode(singleDayForecast)));
      }
    } on Exception {
      return forecasts;
    }
    return forecasts;
  }

  // Future<List<ForecastItem>> getForecastForDateRange(
  //     DateTime dateStart, DateTime dateEnd, PositionItem location) async {
  //   final daysToGenerate = dateEnd.difference(dateStart).inDays;
  //   List<DateTime> days = List.generate(daysToGenerate,
  //       (i) => DateTime(dateStart.year, dateStart.month, dateStart.day + (i)));

  //   List<ForecastItem> result = [];
  //   for (var date in days) {
  //     ForecastItem? forecast = await getForecastForDate(date, location);
  //     if (forecast != null) {
  //       result.add(forecast);
  //     }
  //   }
  //   forecastForRange = result;
  //   return result;
  // }
}
