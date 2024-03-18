import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    guard let controller = window?.rootViewController as? FlutterViewController else{
      fatalError("rootViewController is not type FlutterViewController")
    }
    let channel = FlutterMethodChannel(name: "com.safetynet/mapsApiKey", binaryMessenger: controller.binaryMessenger)
    channel.setMethodCallHandler {[weak self] (call,result) in 
    if call.method == "setApiKey", let args =  call.arguments as? [String: Any], let apiKey = args["apiKey"] as? String {
      GMSServices.provideAPIKey(apiKey)
      result(nil)
    } else {
      result(FlutterMethodNotImplemented)
    }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
