import Flutter
import UIKit
import ExposureNotification

struct CodableDiagnosisKey: Codable, Equatable {
    let keyData: Data
    let rollingPeriod: ENIntervalNumber
    let rollingStartNumber: ENIntervalNumber
    let transmissionRiskLevel: ENRiskLevel
}

struct CodableExposureConfiguration: Codable {
    let minimumRiskScore: ENRiskScore
    let attenuationLevelValues: [ENRiskLevelValue]
    let attenuationWeight: Double
    let daysSinceLastExposureLevelValues: [ENRiskLevelValue]
    let daysSinceLastExposureWeight: Double
    let durationLevelValues: [ENRiskLevelValue]
    let durationWeight: Double
    let transmissionRiskLevelValues: [ENRiskLevelValue]
    let transmissionRiskWeight: Double
}

struct Exposure: Codable {
    let date: Date
    let duration: TimeInterval
    let totalRiskScore: ENRiskScore
    let transmissionRiskLevel: ENRiskLevel
}

struct ExposureSummary: Codable {
  let attenuationDurations: [Int]
  let daysSinceLastExposure: Int
  let matchedKeyCount: UInt64
  let maximumRiskScore: ENRiskLevel
}

@available(iOS 13.5, *)
public class SwiftGactPlugin: NSObject, FlutterPlugin {
  private static var instance: SwiftGactPlugin = SwiftGactPlugin();

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.covidtrace/gact_plugin", binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  let manager = ENManager();
  let configuration = ENExposureConfiguration()
  var userExplanation = "A string that the framework displays to the user informing them of the exposure."
  var exposureSummary: ENExposureDetectionSummary?

  override init() {
    super.init()
    manager.activate { err in
      if let err = err {
        print("Error activating manager: \(err)")
        return
      }

      // Ensure exposure notifications are enabled if the app is authorized. The app
      // could get into a state where it is authorized, but exposure
      // notifications are not enabled,  if the user initially denied Exposure Notifications
      // during onboarding, but then flipped on the "COVID-19 Exposure Notifications" switch
      // in Settings.
      if ENManager.authorizationStatus == .authorized && !self.manager.exposureNotificationEnabled {
        print("Auto enabling exposure notification")
        self.manager.setExposureNotificationEnabled(true) { _ in
            // No error handling for attempts to enable on launch
        }
      }
    }
  }

  deinit {
    manager.invalidate()
  }

  private func getAuthorizationStatus(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
    result(ENManager.authorizationStatus.rawValue)
  }

  // Changes settings to enable Exposure Notification after authorization by the user. 
  private func enableExposureNotification(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
    print("enableExposureNotification \(self.manager.exposureNotificationEnabled) \(ENManager.authorizationStatus.rawValue)")

    guard !self.manager.exposureNotificationEnabled || ENManager.authorizationStatus != .authorized else {
      result(nil)
      return
    }

    self.manager.setExposureNotificationEnabled(true) {err in 
      if let err = err as? ENError {
        result(FlutterError(code: String(err.errorCode), message: ENErrorDomain, details: err.localizedDescription))
        return
      }

      result(nil)
    }
  }

  // Set the Exposure Configuration that will be passed to detectExposures. This method must be
  // called before invoking `detectExposures`. See:
  // https://developer.apple.com/documentation/exposurenotification/enexposureconfiguration
  private func setExposureConfiguration(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
    let config = call.arguments as! [String: Any]

    self.configuration.minimumRiskScore = config["minimumRiskScore"] as! UInt8
    self.configuration.attenuationLevelValues = config["attenuationLevelValues"] as! [NSNumber]
    self.configuration.attenuationWeight = config["attenuationWeight"] as! Double
    self.configuration.daysSinceLastExposureLevelValues = config["daysSinceLastExposureLevelValues"] as! [NSNumber]
    self.configuration.daysSinceLastExposureWeight = config["daysSinceLastExposureWeight"] as! Double
    self.configuration.durationLevelValues = config["durationLevelValues"] as! [NSNumber]
    self.configuration.durationWeight = config["durationWeight"] as! Double
    self.configuration.transmissionRiskLevelValues = config["transmissionRiskLevelValues"] as! [NSNumber]
    self.configuration.transmissionRiskWeight = config["transmissionRiskWeight"] as! Double

    result(nil)
  }

  private func setUserExplanation(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
    self.userExplanation = call.arguments as! String

    result(nil)
  }

  // Performs exposure detection based on previously collected proximity data and keys. 
  private func detectExposures(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
    let filePaths = call.arguments as! [String]
    let localURLs = filePaths.map { (path: String) -> URL in
      return URL(fileURLWithPath: path)
    }

    self.manager.detectExposures(configuration: self.configuration, diagnosisKeyURLs: localURLs) { summary, err in
      if let err = err as? ENError {
        result(FlutterError(code: String(err.errorCode), message: ENErrorDomain, details: err.localizedDescription))
        return
      }

      self.manager.getExposureInfo(summary: summary!, userExplanation: self.userExplanation) { exposures, err in
        if let err = err as? ENError {
          result(FlutterError(code: String(err.errorCode), message: ENErrorDomain, details: err.localizedDescription))
          return
        }

        self.exposureSummary = summary!

        let newExposures = exposures!.map { exposure in
          Exposure(date: exposure.date,
                   duration: exposure.duration,
                   totalRiskScore: exposure.totalRiskScore,
                   transmissionRiskLevel: exposure.transmissionRiskLevel)
        }

        do {
          let encoder = JSONEncoder()
          encoder.dateEncodingStrategy = .millisecondsSince1970
          let json = try encoder.encode(newExposures)
          result(String(data: json, encoding: .utf8))
        } catch {
          result(nil)
        }
      }
    }
  }

  private func getExposureSummary(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
    let summary = self.exposureSummary
    guard summary != nil else {
      result(nil)
      return
    }

    let codable = ExposureSummary(attenuationDurations: summary!.attenuationDurations.map { duration in
          return duration.intValue
        },
        daysSinceLastExposure: summary!.daysSinceLastExposure,
        matchedKeyCount: summary!.matchedKeyCount,
        maximumRiskScore: summary!.maximumRiskScore)

    do {
      let json = try JSONEncoder().encode(codable)
      result(String(data: json, encoding: .utf8))
    } catch {
      result(nil)
    }
  }

  // Requests the Temporary Exposure Keys used by this device to share with a server.
  private func getExposureKeys(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
    let testMode = call.arguments as! Bool;

    if (testMode) {
      self.manager.getTestDiagnosisKeys { keys , error in
        self.diagnosisKeysHandler(keys, error as? ENError, result)
      }
    } else {
      self.manager.getDiagnosisKeys { keys , error in
        self.diagnosisKeysHandler(keys, error as? ENError, result)
      }
    }
  }

  private func diagnosisKeysHandler(_ keys: [ENTemporaryExposureKey]?, _ err: ENError?, _ result: @escaping FlutterResult) {
    if let err = err {
      result(FlutterError(code: String(err.errorCode), message: ENErrorDomain, details: err.localizedDescription))
      return
    }

    guard keys != nil else {
      result(nil)
      return
    }

    // Convert keys to something that can be encoded to JSON and returned by plugin.
    let codableDiagnosisKeys = keys!.compactMap { diagnosisKey -> CodableDiagnosisKey? in
      return CodableDiagnosisKey(keyData: diagnosisKey.keyData,
                                  rollingPeriod: diagnosisKey.rollingPeriod,
                                  rollingStartNumber: diagnosisKey.rollingStartNumber,
                                  transmissionRiskLevel: diagnosisKey.transmissionRiskLevel)
    }
    
    do {
      let json = try JSONEncoder().encode(codableDiagnosisKeys)
      result(String(data: json, encoding: .utf8))
    } catch {
      result(nil)
    }
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "setExposureConfiguration":
      setExposureConfiguration(call, result)
    case "getAuthorizationStatus":
      getAuthorizationStatus(call, result)
    case "enableExposureNotification":
      enableExposureNotification(call, result)
    case "detectExposures":
      detectExposures(call, result)
    case "getExposureSummary":
      getExposureSummary(call, result)
    case "getExposureKeys":
      getExposureKeys(call, result)
    case "setUserExplanation":
      setUserExplanation(call, result)
    default:
      result(FlutterMethodNotImplemented) 
    }
  }
}
