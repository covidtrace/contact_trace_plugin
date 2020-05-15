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

@available(iOS 13.5, *)
public class SwiftGactPlugin: NSObject, FlutterPlugin {
  private static var instance: SwiftGactPlugin = SwiftGactPlugin();

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.covidtrace/gact_plugin", binaryMessenger: registrar.messenger())
    print("REGISTERED \(instance)")
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  let manager = ENManager();

  override init() {
    super.init()
    print("Initialized SwiftGactPlugin")
    manager.activate { error in
      if error != nil {
        print("Error activating manager: \(error)")
      }

      // Ensure exposure notifications are enabled if the app is authorized. The app
      // could get into a state where it is authorized, but exposure
      // notifications are not enabled,  if the user initially denied Exposure Notifications
      // during onboarding, but then flipped on the "COVID-19 Exposure Notifications" switch
      // in Settings.
      if ENManager.authorizationStatus == .authorized && !self.manager.exposureNotificationEnabled {
        self.manager.setExposureNotificationEnabled(true) { _ in
            // No error handling for attempts to enable on launch
        }
      }
    }

  }

  deinit {
    print("SwiftGactPlugin destroyed")
    manager.invalidate()
  }

  private func getAuthorizationStatus(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
    result(ENManager.authorizationStatus)
  }

  // Changes settings to enable Exposure Notification after authorization by the user. 
  private func startTracing(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
    print("startTracing \(self.manager.exposureNotificationEnabled) \(ENManager.authorizationStatus)")

    guard !self.manager.exposureNotificationEnabled else {
      print("returning early")
      result(nil)
      return
    }

    self.manager.setExposureNotificationEnabled(true) {err in 
      print("Completed setExposureNotificationEnabled")

      guard err == nil else {
        print("ENABLE ERROR: \(err)")
        result(err)
        return
      }
    }

    result(nil)
  }

  // Performs exposure detection based on previously collected proximity data and keys. 
  private func detectExposures(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
    var filePaths = call.arguments as! [String]
    var localURLs = filePaths.map { path in
      return URL(string: path)!  
    }

    // TODO(wes): Accept configuration as methodChannel call
    var configuration = ENExposureConfiguration()
    configuration.minimumRiskScore = 0
    configuration.attenuationLevelValues = [1, 2, 3, 4, 5, 6, 7, 8]
    configuration.attenuationWeight = 50
    configuration.daysSinceLastExposureLevelValues = [1, 2, 3, 4, 5, 6, 7, 8]
    configuration.daysSinceLastExposureWeight = 50
    configuration.durationLevelValues = [1, 2, 3, 4, 5, 6, 7, 8]
    configuration.durationWeight = 50
    configuration.transmissionRiskLevelValues = [1, 2, 3, 4, 5, 6, 7, 8]
    configuration.transmissionRiskWeight = 50

    self.manager.detectExposures(configuration: configuration, diagnosisKeyURLs: localURLs) { summary, error in
      if let error = error {
        result(error)
        return
      }

      let userExplanation = "A string that the framework displays to the user informing them of the exposure."
      self.manager.getExposureInfo(summary: summary!, userExplanation: userExplanation) { exposures, error in
        if let error = error {
          result(error)
          return
        }

        let newExposures = exposures!.map { exposure in
          Exposure(date: exposure.date,
                   duration: exposure.duration,
                   totalRiskScore: exposure.totalRiskScore,
                   transmissionRiskLevel: exposure.transmissionRiskLevel)
        }

        do {
          let encoded = try JSONEncoder().encode(newExposures)
          result(String(data: encoded, encoding: .utf8))
        } catch {
          result(nil)
        }
      }
    }
  }

  // Requests the Temporary Exposure Keys used by this device to share with a server.
  private func getExposureKeys(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
    // TODO(wes): Use NON Test version in release build
    self.manager.getTestDiagnosisKeys { keys , error in
      print("Got test diagnosis keys? \(keys)")

      guard error == nil else {
        print("Error getting diagnonis keys \(error)")
        result(error)
        return
      }

      guard keys != nil else {
        print("no diagnosis keys")
        result(nil)
        return
      }

      // Convert keys to something that can be encoded to JSON and upload them.
      let codableDiagnosisKeys = keys!.compactMap { diagnosisKey -> CodableDiagnosisKey? in
        return CodableDiagnosisKey(keyData: diagnosisKey.keyData,
                                    rollingPeriod: diagnosisKey.rollingPeriod,
                                    rollingStartNumber: diagnosisKey.rollingStartNumber,
                                    transmissionRiskLevel: diagnosisKey.transmissionRiskLevel)
      }
      
      do {
        let encoded = try JSONEncoder().encode(codableDiagnosisKeys)
        result(String(data: encoded, encoding: .utf8))
      } catch {
        result(nil)
      }
    }
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "getAuthorizationStatus":
      getAuthorizationStatus(call, result)
    case "startTracing":
      startTracing(call, result)
    case "detectExposures":
      detectExposures(call, result)
    case "getExposureKeys":
      getExposureKeys(call, result)
    default:
      result(FlutterMethodNotImplemented) 
    }
  }
}
