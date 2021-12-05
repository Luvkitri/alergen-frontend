import 'dart:convert';

class ForecastItem {
  late DateTime date;
  late int region;
  late Map<String, int> allergenTypeStrength;

  ForecastItem(
      {required this.date,
      required this.region,
      required this.allergenTypeStrength});

  factory ForecastItem.fromJson(String json) {
    Map<String, dynamic> data = jsonDecode(json);
    final date = DateTime.parse(data['date']);
    final region = data['region'] as int;
    final Map<String, int> allergenTypeStrength =
        Map.castFrom(data['forecast']);
    return ForecastItem(
        date: date, region: region, allergenTypeStrength: allergenTypeStrength);
  }
}

class AllergyForecast {
  late List<ForecastItem> forecast;
}
