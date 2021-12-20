import UIKit
import Flutter
import XmBindIdSDK

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    let bindID = BindID()
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "bindid_flutter_bridge",
                                              binaryMessenger: controller.binaryMessenger)
    channel.setMethodCallHandler({
        [weak self]
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        // Note: this method is invoked on the UI thread.
        switch call.method {
        case "initBindId": self?.bindID.initBindId(call, result: result)
        case "authenticate": self?.bindID.authenticate(call: call, result: result)
        default:
            result("Unknown method: \(call.method)")
        }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
   

}
