import 'dart:async';

import 'package:flutter/services.dart';

/// See https://covid19-static.cdn-apple.com/applications/covid19/current/static/contact-tracing/pdf/ExposureNotification-FrameworkDocumentationv1.1.pdf
/// for details on the Apple API

/// Provides a summary of exposures.
class DetectionSummary {
  /// Number of days since the most recent exposure: 0 = today, 1 = yesterday, and so on. Only valid if
  /// matchedKeyCount > 0.
  final int daysSinceLastExposure;

  /// This property holds the number of keys that matched for an exposure detection.
  final int matchedKeyCount;

  DetectionSummary(this.daysSinceLastExposure, this.matchedKeyCount);
}

/// Contains information about a single contact incident.
class ExposureInfo {
  /// This property holds the date when the exposure occurred. The date may have reduced precision, such as
  /// within one day of the actual time.
  final DateTime date;

  /// This property holds the duration (in minutes) that the contact was in proximity of the user. The minimum
  /// duration is 5 minutes. Other valid values are 10, 15, 20, 25, and 30. The duration is capped at 30 minutes.
  final Duration duration;

  /// This property holds the attenuation value of the peer device at the time the exposure occurred. The
  /// attenuation is the Reported Transmit Power - Measured RSSI.
  final int attenuationValue;

  ExposureInfo(this.date, this.duration, this.attenuationValue);
}

/// The key used to generate Rolling Proximity Identifiers.
class ExposureKey {
  /// This property contains the Temporary Exposure Key information.
  final String keyData;

  /// This property contains the interval number when the key's TKRollingPeriod started.
  final int rollingStartNumber;

  ExposureKey(this.keyData, this.rollingStartNumber);

  /// See: https://covid19-static.cdn-apple.com/applications/covid19/current/static/contact-tracing/pdf/ExposureNotification-CryptographySpecificationv1.1.pdf
  DateTime get timestamp =>
      DateTime.fromMillisecondsSinceEpoch(rollingStartNumber * 60 * 10 * 1000);

  Map<String, dynamic> toMap() {
    return {
      'keyData': keyData,
      'rollingStartNumber': rollingStartNumber,
    };
  }
}

/// A typedef that represents the error codes in the framework.
enum ErrorCode {
  Success,
  Unknown,
  BadParameter,
  NotEntitled,
  NotAuthorized,
  Unsupported,
  Invalidated,
  BluetoothOff,
  InsufficientStorage,
  NotEnabled,
  APIMisuse,
  Internal,
  InsufficientMemory
}

/// An enumeration that specifies the app's preference for authorization with Exposure Notification.
enum AuthorizationMode {
  /// Let the system choose whether to prompt. This is the best option unless you have specific needs. For most
  /// cases, it will prompt the user to authorize (same as `AuthorizationMode.UI`). This gives the system
  /// some flexibility, such as not to prompt if the app is in the background.
  Default,

  /// Authorization will be checked, but it won't prompt the user if the app isn't authorized. If the app is
  /// authorized, the app is allowed to use the service. If the user hasn't been prompted or they denied the app,
  /// operations will fail with `ErrorCode.NotAuthorized`.
  NonUI,

  /// Authorization will be checked and it will prompt the user to authorize, if needed. If the app is authorized by
  /// the user, the app is allowed to use the service. If the user denies the app, operations will fail with
  /// `ErrorCode.NotAuthorized`.
  UI,
}

/// An enumeration that indicates the status of authorization for the app.
enum AuthorizationStatus {
  /// Authorization status has not yet been determined.
  Unknown,

  /// This app is not authorized to use Exposure Notification. The user cannot change this app's authorization
  /// status. This status may be due to active restrictions, such as parental controls being in place.
  Restricted,

  /// The user denied authorization for this app.
  NotAuthorized,

  /// The user has authorized this app to use Exposure Notification.
  Authorized,
}

class GactPlugin {
  static const MethodChannel _channel =
      const MethodChannel('com.covidtrace/gact_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// This property reports the current authorization status of the app and never prompts the user. It can be used
  /// by the app for preflight authorization to determine if the user may be prompted.
  static Future<AuthorizationStatus> get authorizationStatus async {
    int status = await _channel.invokeMethod('getAuthorizationStatus');

    switch (status) {
      case 1:
        return AuthorizationStatus.Restricted;
      case 2:
        return AuthorizationStatus.NotAuthorized;
      case 3:
        return AuthorizationStatus.Authorized;
      default:
        return AuthorizationStatus.Unknown;
    }
  }

  /// This property specifies the app's preference for authorization with Exposure Notification. It defaults to
  /// prompting the user to authorize, if needed.
  static Future<AuthorizationMode> get authorizationMode async {
    int mode = await _channel.invokeMethod('getAuthorizationMode');

    switch (mode) {
      case 1:
        return AuthorizationMode.NonUI;
      case 2:
        return AuthorizationMode.UI;
      default:
        return AuthorizationMode.Default;
    }
  }

  /// Requests the current settings for Exposure Notification.
  static Future<Map<dynamic, dynamic>> get settings async {
    Map<dynamic, dynamic> value = await _channel.invokeMethod('getSettings');

    return value;
  }

  /// Changes settings for Exposure Notification after authorization by the user.
  static Future<void> setSettings(Map<String, dynamic> options) async {
    await _channel.invokeMethod('setSettings', options);
  }

  /// Performs exposure detection based on previously collected proximity data and keys.
  static Future<List<ExposureInfo>> checkExposure(
      List<ExposureKey> keys) async {
    List<dynamic> exposures = await _channel.invokeMethod(
        'checkExposure', keys.map((k) => k.toMap()).toList());

    return exposures
        .map((e) => ExposureInfo(
            DateTime.fromMillisecondsSinceEpoch(e["date"].toInt() * 1000),
            Duration(minutes: e["duration"]),
            e["attenuationValue"]))
        .toList();
  }

  /// Requests the Temporary Exposure Keys used by this device to share with a server.
  ///
  /// This request is intended to be called when a user has received a positive diagnosis. Once the keys are
  /// shared with a server, other users can use the keys to check if their device has been in close proximity with
  /// any positively diagnosed users, enough to cause an exposure incident. Each request results in the user
  /// being notified by the operating system.
  /// Keys are reported for the previous 14 days of exposure notification. The returned keys are at least 24 hours
  /// old.
  /// The app must have previously enabled Exposure Notification through the settings API (which requires
  /// approval by the user). If the app hasn't done that, this request fails with ENErrorCodeNotEnabled.
  static Future<Iterable<ExposureKey>> getExposureKeys() async {
    List<dynamic> keys = await _channel.invokeMethod('getExposureKeys');

    return keys.map((key) =>
        ExposureKey(key["keyData"], key["rollingStartNumber"].toInt()));
  }

  /// Deletes all collected exposure data and Temporary Exposure Keys.
  /// Note: This object eliminates the ability to detect exposure that may have occurred before the point of
  /// reset. Each request prompts the user to authorize the request.
  static Future<void> reset() async {
    await _channel.invokeMethod('reset');
  }
}
