import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

enum PositionItemType {
  log,
  position,
}

class PositionItem {
  PositionItem(this.type, this.displayValue, this.latitude, this.longitude);

  final PositionItemType type;
  final String displayValue;
  final double? latitude;
  final double? longitude;
}

class GeoService {
  static const String _kLocationServicesDisabledMessage =
      'Location services are disabled.';
  static const String _kPermissionDeniedMessage = 'Permission denied.';
  static const String _kPermissionDeniedForeverMessage =
      'Permission denied forever.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';

  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final List<PositionItem> _positionItems = <PositionItem>[];

  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<ServiceStatus>? _serviceStatusStreamSubscription;
  bool positionStreamStarted = false;

  PositionItem getLastPosition() {
    return _positionItems.last;
  }

  List<double> _positionStringToCoords(String pos) {
    pos = pos.replaceAll("Latitude: ", "").replaceAll(" Longitude: ", "");
    return pos.split(",").map(double.parse).toList();
  }

  void _updatePositionList(PositionItemType type, String displayValue) {
    double lat = 0;
    double long = 0;
    try {
      List<double> coords = _positionStringToCoords(displayValue);
      if (coords.length == 2) {
        lat = coords[0];
        long = coords[1];
      }
    } catch (e) {}

    _positionItems.add(PositionItem(type, displayValue, lat, long));
  }

  Future<String?> getCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return null;
    }

    final position = await _geolocatorPlatform.getCurrentPosition();
    _updatePositionList(
      PositionItemType.position,
      position.toString(),
    );
    return position.toString();
  }

  Future<String?> getLastKnownPosition() async {
    final position = await _geolocatorPlatform.getLastKnownPosition();
    if (position != null) {
      _updatePositionList(
        PositionItemType.position,
        position.toString(),
      );
      return position.toString();
    } else {
      _updatePositionList(
        PositionItemType.log,
        'No last known position available',
      );
      return null;
    }
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      _updatePositionList(
        PositionItemType.log,
        _kLocationServicesDisabledMessage,
      );

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        _updatePositionList(
          PositionItemType.log,
          _kPermissionDeniedMessage,
        );

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      _updatePositionList(
        PositionItemType.log,
        _kPermissionDeniedForeverMessage,
      );

      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _updatePositionList(
      PositionItemType.log,
      _kPermissionGrantedMessage,
    );
    return true;
  }
}
