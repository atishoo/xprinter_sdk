import Flutter
import UIKit

public class XprinterSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "xprinter_sdk", binaryMessenger: registrar.messenger())
    let instance = XprinterSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "startScanBluetooth":
      result("iOS " + UIDevice.current.systemVersion)
    case "stopScanBluetooth":
    case "connectDevice":
    case "disconnectDevice":
    case "writeCommand":
    case "initializePrinter":
    case "setMag":
    case "setAlignment":
    case "setSpeedLevel":
    case "setPageWidth":
    case "setBeepLength":
    case "drawText":
    case "drawBarcode":
    case "addBarcodeText":
    case "removeBarcodeText":
    case "drawQRCode":
    case "drawImage":
    case "drawBox":
    case "drawLine":
    case "drawInverseLine":
    case "setStringEncoding":
    case "print":
      result("iOS " + UIDevice.current.systemVersion)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
