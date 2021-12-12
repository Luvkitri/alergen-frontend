import 'package:frontend/models/forecast_model.dart';
import 'package:frontend/models/geo_model.dart';
import 'package:http/http.dart' as http;

class ForecastService {
  static String baseUrl = '10.0.2.2:8001';

  Future<ForecastItem> getForecastForDate(
      DateTime date, PositionItem location) async {
    final queryParameters = {
      'now': date.toIso8601String().substring(0, 10),
      'lat': '${location.latitude}',
      'lon': '${location.longitude}'
    };

    Uri uri = Uri.http(baseUrl, '/api/getPerRegion', queryParameters);
    http.Response response = await http.get(uri, headers: {});
    return ForecastItem.fromJson(response.body);
  }

  Future<List<ForecastItem>> getForecastForDateRange(
      DateTime dateStart, DateTime dateEnd, PositionItem location) async {
    final daysToGenerate = dateEnd.difference(dateStart).inDays;
    List<DateTime> days = List.generate(daysToGenerate,
        (i) => DateTime(dateStart.year, dateStart.month, dateStart.day + (i)));

    List<ForecastItem> result = [];
    for (var date in days) {
      var forecast = await getForecastForDate(date, location);
      result.add(forecast);
    }
    return result;
  }
}
