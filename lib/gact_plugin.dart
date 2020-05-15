import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter/services.dart';
import 'package:gact_plugin/diagnosisKeyURL.pb.dart';

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

  final int rollingPeriod;

  final int transmissionRiskLevel;

  ExposureKey(this.keyData, this.rollingPeriod, this.rollingStartNumber,
      this.transmissionRiskLevel);

  /// See: https://covid19-static.cdn-apple.com/applications/covid19/current/static/contact-tracing/pdf/ExposureNotification-CryptographySpecificationv1.1.pdf
  DateTime get timestamp =>
      DateTime.fromMillisecondsSinceEpoch(rollingStartNumber * 60 * 10 * 1000);

  Map<String, dynamic> toMap() {
    return {
      'keyData': keyData,
      'rollingPeriod': rollingPeriod,
      'rollingStartNumber': rollingStartNumber,
      'transmissionRiskLevel': transmissionRiskLevel,
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

  /// Enables exposure notification.
  static Future<void> startTracing() async {
    await _channel.invokeMethod('startTracing');
  }

  /// Detects exposures using the specified configuration to control the scoring algorithm.
  static Future<List<ExposureInfo>> detectExposures(List<Uri> keyFiles) async {
    List<dynamic> exposures = await _channel.invokeMethod(
        'detectExposures', keyFiles.map((u) => u.toFilePath()).toList());

    return exposures
        .map((e) => ExposureInfo(
            DateTime.fromMillisecondsSinceEpoch(e["date"].toInt() * 1000),
            Duration(minutes: e["duration"]),
            e["attenuationValue"]))
        .toList();
  }

  /// Requests the temporary exposure keys from the user’s device to share with a server.
  ///
  /// Note: Each time you call this method, the system presents an interface requesting authorization.
  static Future<Iterable<ExposureKey>> getExposureKeys() async {
    String result = await _channel.invokeMethod('getExposureKeys');
    List<dynamic> keys = result != null ? jsonDecode(result) : [];

    return keys.map((key) => ExposureKey(
        key["keyData"],
        key["rollingPeriod"].toInt(),
        key["rollingStartNumber"].toInt(),
        key["transmissionRiskLevel"]));
  }

  static Future<void> saveExposureKeyFile(
      Iterable<ExposureKey> keys, io.File fileHandle) async {
    var file = File.create();
    keys.forEach((ek) {
      var key = Key();
      key.keyData = base64.decode(ek.keyData);
      key.rollingPeriod = ek.rollingPeriod;
      key.rollingStartNumber = ek.rollingStartNumber;
      key.transmissionRiskLevel = ek.transmissionRiskLevel;

      file.key.add(key);
    });

    if (!await fileHandle.exists()) {
      await fileHandle.create(recursive: true);
    }

    await fileHandle.writeAsBytes(file.writeToBuffer());
  }
}
