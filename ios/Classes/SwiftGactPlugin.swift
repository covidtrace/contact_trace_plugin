import Flutter
import UIKit

public class SwiftGactPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.covidtrace/gact_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftGactPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  private func getAuthorizationStatus(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
    result(1) //  ENAuthorizable.authorizationStatus
  }

  private func getAuthorizationMode(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
    result(0) //  ENAuthorizable.authorizationMode
  }

  // Requests the current settings for Exposure Notification. 
  private func getSettings(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
    /*
    1. Create an instance of ENSettingsGetRequest.
    2. Optionally set the dispatch queue if you want the completion handler to be invoked on something other
       than the main queue.
    3. Call activateWithCompletion to asynchronously get settings from the system.
    4. When the activation completes successfully, the settings property is valid to access.
    5. Access the needed information in the settings object. You may retain it for use after invalidating the
       request, if needed.
    6. Call invalidate.
    */

    // Resulting values has `settings` object with `enableState` Boolean. use a Dictionary for serialization to `result`
    result(["settings": ["enableState": true]])
  }


  // Changes settings for Exposure Notification after authorization by the user. 
  private func setSettings(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
    /*
    1. Create an instance of ETMutableSettings (or call mutableCopy on an immutable ENSettings
       instance).
    2. Set properties of the settings instance to change any settings.
    3. Create an instance of ENSettingsChangeRequest.
    4. Set the settings property to the settings instance.
    5. Optionally set the dispatch queue if you want the completion handler to be invoked on something other
       than the main queue.
    6. Call activateWithCompletion to asynchronously change settings if authorized by the user.
       Authorization happens when activateWithCompletion is called. The user may be prompted at this
       point.
    7. When the activation completes successfully, the new settings are applied.
    8. Call invalidate. 
    */

    var options = call.arguments as? Dictionary<String, Any>
    result(nil)
  }

  // Performs exposure detection based on previously collected proximity data and keys. 
  private func checkExposure(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
    /*
    1. Create an instance of ENExposureDetectionSession.
    2. Optionally, set the dispatch queue if you want the completion handler to be invoked on something other
       than the main queue.
    3. Call activateWithCompletion to asynchronously prepare the session for use.
    4. Wait for the completion handler for activateWithCompletion to be invoked with a nil error.
    5. Call addDiagnosisKeys with up to maxKeyCount keys.
    6. Wait for the completion handler for addDiagnosisKeys to be invoked with a nil error.
    7. Repeat the previous two steps until all keys are provided to the system or an error occurs.
    8. Call finishedDiagnosisKeysWithCompletion.
    9. Wait for the completion handler for finishedDiagnosisKeysWithCompletion to be invoked with a
       nil error.

    If the summary indicates matches were found, notify the user of exposure. If the user is interested in
    sharing more details with the app:

      1. Call getExposureInfoWithMaxCount. Use a reasonable maximum count, such as 100.
      2. Wait for the completion handler for getExposureInfoWithMaxCount to be invoked with a nil
         error.
      3. If the value of the completion handler's inDone parameter is NO, repeat the previous two steps
         until the value is YES or an error occurs.

    When the app is done with the session, call invalidate. 
    */
    var keys = call.arguments as? Array<Dictionary<String, Any>>

    // Arguments to set on session class
    // attenuationThreshold = 0
    // durationThreshold = 5 minutes

    result([])
  }

  // Requests the Temporary Exposure Keys used by this device to share with a server.
  private func getExposureKeys(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
    /*
    1. Create an instance of ENSelfExposureInfoRequest.
    2. Optionally set the dispatch queue if you want the completion to be invoked on something other than the
       main queue.
    3. Call activateWithCompletion to asynchronously start the request.
    4. When the activation completes successfully, the selfExposureInfo property is valid to access.
    5. Access information in the selfExposureInfo object. You may retain it for use after invalidating the
       request, if needed.
    6. Call invalidate.
    */

    result([])
  }

  /// Deletes all collected exposure data and Temporary Exposure Keys. 
  private func reset(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
    // Use ENSelfExposureResetRequest
    result(nil)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "getAuthorizationStatus":
      getAuthorizationStatus(call, result)
    case "getAuthorizationMode":
      getAuthorizationMode(call, result)
    case "getSettings":
      getSettings(call, result)
    case "setSettings":
      setSettings(call, result)
    case "checkExposure":
      checkExposure(call, result)
    case "getExposureKeys":
      getExposureKeys(call, result)
    case "reset":
      reset(call, result)
    default:
      result(FlutterMethodNotImplemented) 
    }
  }
}
