import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/constants/route_names.dart';
import 'package:frontend/models/forecast_model.dart';
import 'package:frontend/services/forecast_service.dart';
import 'package:frontend/services/geo_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:collection';

import '../locator.dart';
import 'navigation_service.dart';

class NotificationService {
  final ForecastService _forecastService = locator<ForecastService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final GeoService _geoService = locator<GeoService>();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late FlutterSecureStorage storage;
  Future init() async {
    storage = const FlutterSecureStorage();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Warsaw'));
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );
  }

  Future showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'Watch out! Today there may be allergens in air!',
      'Check out the forecast tab in Allergen app.',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: "ic_notif_ico",
    );
    await _geoService.getCurrentPosition();
    ForecastItem? forecastItem = await _forecastService.getForecastForDate(
      DateTime.now(),
      _geoService.getLastPosition(),
    );
    forecastItem?.allergenTypeStrength.removeWhere((key, value) => value < 1);
    var temp = forecastItem?.allergenTypeStrength ?? <String, int>{};
    var sortedKeys = temp.keys.toList(growable: false)
      ..sort((k1, k2) => temp[k2]!.compareTo(temp[k1]!.toInt()));
    LinkedHashMap<String, int> sortedMap = LinkedHashMap.fromIterable(
        sortedKeys,
        key: (k) => k,
        value: (k) => temp[k]!);
    int end = sortedMap.length <= 3 ? sortedMap.length : 3;
    String allergens = sortedMap.keys.toList().sublist(0, end).join(', ');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    String title = allergens.isEmpty
        ? "There aren't any allergens in the air today!"
        : "Watch out! This allergens are in the air today:";
    String body = allergens.isEmpty
        ? 'Check out the forecast tab in Allergen app for more info.'
        : allergens;
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'forecast',
    );
  }

  void selectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    _navigationService.navigateTo(forecastRoute);
  }

  Future scheduleForecastNotification() async {
    var lastScheduledNotificaion =
        await storage.read(key: 'lastScheduledNotification') ??
            DateTime.now().toString();
    await storage.write(
        key: 'lastScheduledNotification', value: DateTime.now().toString());
    var last = DateTime.parse(lastScheduledNotificaion);
    var now = DateTime.now();
    var today = DateTime.utc(now.year, now.month, now.day, 10, 0, 0);
    var diffFromSetHour = today.difference(now);
    var diff = now.difference(last);
    if (_forecastService.forecastForRange.isEmpty) {
      return;
    }
    if (diff.inDays >= 1 || true) {
      await flutterLocalNotificationsPlugin.cancelAll();

      for (var element in _forecastService.forecastForRange) {
        var timeToShow = tz.TZDateTime.from(element.date, tz.local).add(
          Duration(seconds: diffFromSetHour.inSeconds),
        );

        await flutterLocalNotificationsPlugin.zonedSchedule(
          0,
          'Watch out! Today there may be allergens in air!',
          'Check out the forecast tab in Allergen app.',
          timeToShow,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'allergerNotification',
              'allergerNotification',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }
    }
  }
}
