import 'dart:convert';

import 'package:frontend/models/forecast_model.dart';
import 'package:frontend/models/geo_model.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;

class ForecastService {
  static String baseUrl = 'ourForecastApi.com:5000';
  //https://github.com/dart-lang/http/blob/master/test/mock_client_test.dart
  var api = MockClient((request) async => http.Response(
      '{"date":"2021-12-05", "region":3, "forecast":{"brzoza":3, "konopie":4, "wierzba":2} }',
      200,
      request: request,
      headers: {'content-type': 'application/json'}));

  Future<ForecastItem> getForecastForDate(
      DateTime date, PositionItem location) async {
    // TODO: actual api call, when ready
    // for now, mock
    http.Response response = await api.post(Uri.http(baseUrl, '/forecast'),
        body: jsonEncode({
          'date': date.toIso8601String(),
          'latitude': location.latitude,
          'longitude': location.longitude
        }));
    return ForecastItem.fromJson(response.body);
  }
}
