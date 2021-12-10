import 'dart:convert';
import 'dart:math';

import 'package:frontend/models/forecast_model.dart';
import 'package:frontend/models/geo_model.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;

class ForecastService {
  static String baseUrl = 'ourForecastApi.com:5000';

  //https://github.com/dart-lang/http/blob/master/test/mock_client_test.dart
  var api = MockClient((request) async {
    Random random = Random();

    print(request.body);
    Map<String, dynamic> body = jsonDecode(request.body);

    List<dynamic> responseBody = [];

    if (body.containsKey('latitude') && body.containsKey('longitude')) {
      int region = 3;

      if (body.containsKey('dateStart') && body.containsKey('dateEnd')) {
        //return range forecast
        DateTime dateStart = DateTime.parse(body['dateStart']);
        DateTime dateEnd = DateTime.parse(body['dateEnd']);
        for (int i = 0; i <= dateEnd.difference(dateStart).inDays; i++) {
          var d = dateStart.add(Duration(days: i));

          responseBody.add({
            "date": d.toIso8601String(),
            "region": region,
            "allergens": {
              "brzoza": random.nextInt(3),
              "wierzba": random.nextInt(3),
              "konopie": random.nextInt(3),
            }
          });
        }
      } else if (body.containsKey('date')) {
        //return single forecast
        responseBody = [
          {
            "date": body['date'],
            "region": region,
            "allergens": {
              "brzoza": random.nextInt(3),
              "wierzba": random.nextInt(3),
              "konopie": random.nextInt(3),
            }
          }
        ];
      }
    }

    return http.Response(jsonEncode(responseBody), 200,
        request: request, headers: {'content-type': 'application/json'});
  });

  Future<ForecastItem> getForecastForDate(
      DateTime date, PositionItem location) async {
    // TODO: actual api call, when ready
    // for now, mock
    // print("getForecastForDate");
    http.Response response = await api.post(Uri.http(baseUrl, '/forecast'),
        headers: {'content-type': 'application/json'},
        body: jsonEncode({
          'date': date.toIso8601String(),
          'latitude': location.latitude,
          'longitude': location.longitude
        }));
    List<dynamic> forecasts = jsonDecode(response.body);
    List<ForecastItem> result = [];
    for (var element in forecasts) {
      result.add(ForecastItem.fromJson(jsonEncode(element)));
    }
    return result.first;
  }

  Future<List<ForecastItem>> getForecastForDateRange(
      DateTime dateStart, DateTime dateEnd, PositionItem location) async {
    // TODO: actual api call, when ready
    // for now, mock
    // print("getForecastForDateRange");
    http.Response response = await api.post(Uri.http(baseUrl, '/forecast'),
        headers: {'content-type': 'application/json'},
        body: jsonEncode({
          'dateStart': dateStart.toIso8601String(),
          'dateEnd': dateEnd.toIso8601String(),
          'latitude': location.latitude,
          'longitude': location.longitude
        }));
    List<dynamic> forecasts = jsonDecode(response.body);

    List<ForecastItem> result = [];
    for (var element in forecasts) {
      result.add(ForecastItem.fromJson(jsonEncode(element)));
    }
    return result;
  }
}
