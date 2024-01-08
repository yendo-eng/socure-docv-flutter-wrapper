import Flutter
import UIKit
import SocureDocV
import DeviceRisk

public class SwiftSocurePlugin: NSObject, FlutterPlugin {
    let objDocVHelper = SocureDocVHelper()
    var controller: UIViewController
    let callResult = { (result: @escaping FlutterResult, data: Any) in
        result(data)
    }

    init(uiViewController: UIViewController) {
        controller = uiViewController
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "socure", binaryMessenger: registrar.messenger())
        let viewController: UIViewController = (UIApplication.shared.delegate?.window??.rootViewController)!;
        let instance = SwiftSocurePlugin(uiViewController: viewController)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

        var resultHandler: ((Result<ScannedData, ScanError>) -> Void) {
            {
                switch $0 {
                case .success(let data):
                    let responseData = data.dictionary.convertToStr()
                    result(responseData)
                    break;
                case .failure(let error):
                    let responseError = error.dictionary.convertToStr()
                    result(responseError)
                    break;
                }
            }
        }
        let arguments = call.arguments as! Dictionary<String, Any>
        switch call.method {
        case "docV":
            let socureSdkKey: String = arguments["sdkKey"] as! String
            let documentType: String = arguments["documentType"] as! String
            let language: String = arguments["language"] as! String
            
            let config = ["document_type": documentType, "language": language]

            objDocVHelper.launch(
                    socureSdkKey,
                    presentingViewController: controller,
                    config: config,
                    completionBlock: resultHandler
            )
            return
        case "fingerprint":
            let socureSdkKey: String = arguments["sdkKey"] as! String

            let config = SocureSigmaDeviceConfig(SDKKey: socureSdkKey)
            let options = SocureFingerprintOptions(context: .homepage)

            SocureSigmaDevice.fingerprint(config: config, options: options) { fingerprintResult, error in
                if let deviceSessionID = fingerprintResult?.deviceSessionID {
                    result(deviceSessionID)
                } else if let _ = error {
                    result("Socure Fingerprint - Something went wrong")
                }
            }
            return
        default:
            result(FlutterMethodNotImplemented)
            return
        }
    }
}

extension String {
    func convertToDictionary() throws -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                throw error
            }
        }
        return nil
    }
}

extension Dictionary {
    func convertToStr() -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
            let jsonString = String(data: jsonData, encoding: String.Encoding.ascii)
            return jsonString
        } catch {
            return nil
        }
    }
}