import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator_android/geolocator_android.dart';

import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

export 'package:geolocator_android/geolocator_android.dart'
    show AndroidSettings, ForegroundNotificationConfig, AndroidResource;
export 'package:geolocator_apple/geolocator_apple.dart'
    show AppleSettings, ActivityType;
export 'package:geolocator_platform_interface/geolocator_platform_interface.dart';


class Geolocator {
  /// Returns a [Future] indicating if the user allows the App to access
  /// the device's location.
  static Future<LocationPermission> checkPermission() =>
      GeolocatorPlatform.instance.checkPermission();

  
  static Future<LocationPermission> requestPermission() =>
      GeolocatorPlatform.instance.requestPermission();

  /// Returns a [Future] containing a [bool] value indicating whether location
  
  static Future<bool> isLocationServiceEnabled() =>
      GeolocatorPlatform.instance.isLocationServiceEnabled();

 
  static Future<Position?> getLastKnownPosition(
          {bool forceAndroidLocationManager = false}) =>
      GeolocatorPlatform.instance.getLastKnownPosition(
          forceLocationManager: forceAndroidLocationManager);

 
  static Future<Position> getCurrentPosition({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best,
    bool forceAndroidLocationManager = false,
    Duration? timeLimit,
  }) {
    late LocationSettings locationSettings;
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
        accuracy: desiredAccuracy,
        forceLocationManager: forceAndroidLocationManager,
        timeLimit: timeLimit,
      );
    } else {
      locationSettings = LocationSettings(
        accuracy: desiredAccuracy,
        timeLimit: timeLimit,
      );
    }

    return GeolocatorPlatform.instance
        .getCurrentPosition(locationSettings: locationSettings);
  }

  
  static Stream<Position> getPositionStream({
    LocationSettings? locationSettings,
  }) =>
      GeolocatorPlatform.instance.getPositionStream(
        locationSettings: locationSettings,
      );

  
  static Stream<ServiceStatus> getServiceStatusStream() =>
      GeolocatorPlatform.instance.getServiceStatusStream();

  
  static Future<LocationAccuracyStatus> requestTemporaryFullAccuracy({
    required String purposeKey,
  }) =>
      GeolocatorPlatform.instance.requestTemporaryFullAccuracy(
        purposeKey: purposeKey,
      );

  
  static Future<bool> openAppSettings() =>
      GeolocatorPlatform.instance.openAppSettings();

  
  static Future<bool> openLocationSettings() =>
      GeolocatorPlatform.instance.openLocationSettings();

  
  static double distanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) =>
      GeolocatorPlatform.instance.distanceBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );

  
  static double bearingBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) =>
      GeolocatorPlatform.instance.bearingBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );
}