import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:gact_plugin/diagnosisKeyURL.pb.dart';
import 'package:gact_plugin/export.pb.dart';

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

/// This class carries information about an exposure incident.
class ExposureInfo {
  /// The date the exposure occurred.
  final DateTime date;

  /// The length of time in minutes that the contact was in proximity to the user.
  final Duration duration;

  /// The total risk calculated for an exposure incident.
  final int totalRiskScore;

  /// The transmission risk associated with a diagnosis key.
  final int transmissionRiskLevel;

  ExposureInfo(this.date, this.duration, this.totalRiskScore,
      this.transmissionRiskLevel);
}

/// The key used to generate Rolling Proximity Identifiers.
class ExposureKey {
  /// The temporary exposure key information.
  final String keyData;

  /// A number that indicates when a key’s rolling period started.
  final int rollingStartNumber;

  /// The length of time that this key is valid.
  final int rollingPeriod;

  /// The risk of transmission associated with the person a key came from.
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

/// A summary of exposures.
class ExposureSummary {
  /// An array of durations at certain radio signal attenuations.
  final List<Duration> attenuationDurations;

  /// Number of days since the most recent exposure.
  final int daysSinceLastExposure;

  /// The number of keys that matched for an exposure detection.
  final int matchedKeyCount;

  /// The highest risk score of all exposure incidents.
  final int maximumRiskScore;

  /// Exposure summary meta data.
  final Map<String, dynamic> metadata;

  ExposureSummary(this.attenuationDurations, this.daysSinceLastExposure,
      this.matchedKeyCount, this.maximumRiskScore, this.metadata);
}

/// Errors that the exposure notification framework issues.
/// See: https://developer.apple.com/documentation/exposurenotification/enerror
enum ErrorCode {
  reserved, // Unused
  unknown, // 1
  badParameters, // 2
  notEntitled, // 3
  notAuthorized, // 4
  unsupported, // 5
  invalidated, // 6
  bluetoothOff, // 7
  insufficientStorage, // 8
  notEnabled, // 9
  apiMisuse, //  10
  internal, // 11
  insufficientMemory, // 12
  rateLimited, // 13
  restricted, // 14
  badFormat, // 15
}

const AndroidErrorCodes = {
  10: ErrorCode.badFormat,
  17: ErrorCode.notEntitled,
  99: ErrorCode.unsupported,
};

ErrorCode errorFromException(err) {
  var code = int.parse(err.code);
  return io.Platform.isAndroid
      ? AndroidErrorCodes[code]
      : ErrorCode.values[code];
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

  // The Exposure Notification API is not supported on this device
  Unsupported,
}

enum ExposureNotificationStatus {
  Unknown, // 0
  Active, // 1
  Disabled, // 2
  BluetoothOff, // 3
  Restricted, // 4
  Paused, // 5
  NotAuthorized, // 6
}

class GactPlugin {
  static const MethodChannel _channel =
      const MethodChannel('com.covidtrace/gact_plugin');

  static Completer<ExposureSummary> _detectExposuresResult;

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> get deviceCheck async {
    return _channel.invokeMethod('getDeviceCheck');
  }

  /// This property reports the current authorization status of the app and never prompts the user. It can be used
  /// by the app for preflight authorization to determine if the user may be prompted.
  static Future<AuthorizationStatus> get authorizationStatus async {
    int status;
    try {
      status = await _channel
          .invokeMethod('getAuthorizationStatus')
          .timeout(Duration(seconds: 2), onTimeout: () {
        return 4; // This is a workaround for Android GPS incompatibilty exception
      });
    } catch (err) {
      status = 4;
    }

    switch (status) {
      case 1:
        return AuthorizationStatus.Restricted;
      case 2:
        return AuthorizationStatus.NotAuthorized;
      case 3:
        return AuthorizationStatus.Authorized;
      case 4:
        return AuthorizationStatus.Unsupported;
      default:
        return AuthorizationStatus.Unknown;
    }
  }

  static Future<ExposureNotificationStatus>
      get exposureNotificationStatus async {
    var status;
    try {
      status = await _channel
          .invokeMethod('getExposureNotificationStatus')
          .timeout(Duration(seconds: 2), onTimeout: () {
        return 0;
      });
    } catch (err) {
      status = 0;
    }

    // Android API returns a set serialized as a string, eg: [BLUETOOTH_DISABLED, INACTIVATED]
    // See: https://developers.google.com/android/reference/com/google/android/gms/nearby/exposurenotification/ExposureNotificationStatus
    if (status is String) {
      var set = Set.from(status.substring(1, status.length - 1).split(', '));
      if (set.contains('ACTIVATED')) {
        status = 1;
      } else if (set.contains('BLUETOOTH_DISABLED')) {
        status = 3;
      } else if (set.contains('INACTIVATED')) {
        status = 2;
      } else if (set.contains('FOCUS_LOST')) {
        status = 6;
      } else {
        status = 0;
      }
    }

    switch (status) {
      case 1:
        return ExposureNotificationStatus.Active;
      case 2:
        return ExposureNotificationStatus.Disabled;
      case 3:
        return ExposureNotificationStatus.BluetoothOff;
      case 4:
        return ExposureNotificationStatus.Restricted;
      case 5:
        return ExposureNotificationStatus.Paused;
      case 6:
        return ExposureNotificationStatus.NotAuthorized;
      case 0:
      default:
        return ExposureNotificationStatus.Unknown;
    }
  }

  /// Enables exposure notification.
  static Future<AuthorizationStatus> enableExposureNotification() async {
    await _channel.invokeMethod('enableExposureNotification');
    return authorizationStatus;
  }

  /// Sets the exposures configuration to control the scoring algorithm.
  /// This method must be called before invoking `detectExposures`.
  /// For details on specifying a configuration see:
  /// https://developer.apple.com/documentation/exposurenotification/enexposureconfiguration
  static Future<void> setExposureConfiguration(
      Map<String, dynamic> config) async {
    await _channel.invokeMethod('setExposureConfiguration', config);
  }

  static Future<void> setUserExplanation(String explanation) async {
    await _channel.invokeMethod('setUserExplanation', explanation);
  }

  /// Detects exposures using the specified configuration to control the scoring algorithm.
  static Future<ExposureSummary> detectExposures(List<Uri> keyFiles) async {
    Future result = _channel.invokeMethod(
        'detectExposures', keyFiles.map((u) => u.toFilePath()).toList());

    if (Platform.isAndroid) {
      _detectExposuresResult = new Completer<ExposureSummary>();

      Timer.periodic(Duration(seconds: 5), (timer) async {
        var done = await _channel.invokeMethod('exposureCheckComplete');
        if (done) {
          timer.cancel();
          var info = await getExposureSummary();
          _detectExposuresResult.complete(info);
        }
      });

      return _detectExposuresResult.future;
    }

    String info = await result;
    var summary = jsonDecode(info);
    var durations =
        (summary["attenuationDurations"] as List).cast<int>().toList();

    return ExposureSummary(
      durations.map((d) => Duration(seconds: d)).toList(),
      summary["daysSinceLastExposure"],
      summary["matchedKeyCount"],
      summary["maximumRiskScore"],
      summary["metadata"],
    );
  }

  static Future<void> inspectExportFile(Uri uri) async {
    print('Inspecting export bin file: $uri');
    var binFile = io.File(uri.toFilePath());
    try {
      // Protobuf starts after fixed 16-byte header
      var export = TemporaryExposureKeyExport.fromBuffer(
          (await binFile.readAsBytes()).sublist(16));
      print(export);
    } catch (err) {
      print(err);
    }
  }

  /// Returns the most recent exposure summary. This method must be called after first
  /// invoking `detectExposures`.
  static Future<ExposureSummary> getExposureSummary() async {
    var result = await _channel.invokeMethod('getExposureSummary');
    if (result == null) {
      return null;
    }

    var summary = jsonDecode(result);
    var durations =
        (summary["attenuationDurations"] as List).cast<int>().toList();

    return ExposureSummary(
      durations.map((d) => Duration(seconds: d)).toList(),
      summary["daysSinceLastExposure"],
      summary["matchedKeyCount"],
      summary["maximumRiskScore"],
      summary["metadata"],
    );
  }

  static Future<List<ExposureInfo>> getExposureInfo() async {
    var result = await _channel.invokeMethod('getExposureInfo');
    if (result == null) {
      return null;
    }

    var infos = jsonDecode(result) as List;
    return infos
        .map((e) => ExposureInfo(
            DateTime.fromMillisecondsSinceEpoch(e["date"].toInt()),
            Duration(seconds: e["duration"]),
            e["totalRiskScore"],
            e["transmissionRiskLevel"]))
        .toList();
  }

  /// Requests the temporary exposure keys from the user’s device to share with a server.
  ///
  /// Note: Each time you call this method, the system presents an interface requesting authorization.
  static Future<Iterable<ExposureKey>> getExposureKeys(
      {bool testMode = false}) async {
    String result = await _channel.invokeMethod('getExposureKeys', testMode);
    List<dynamic> keys = result != null ? jsonDecode(result) : [];

    return keys.map((key) => ExposureKey(
          key["keyData"],
          key["rollingPeriod"].toInt(),
          key["rollingStartNumber"].toInt(),
          key["transmissionRiskLevel"],
        ));
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
