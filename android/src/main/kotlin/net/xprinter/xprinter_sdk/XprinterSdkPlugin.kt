package net.xprinter.xprinter_sdk

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import net.posprinter.POSConnect

/** XprinterSdkPlugin */
class XprinterSdkPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "xprinter_sdk")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "startScanBluetooth") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
      POSConnect.createDevice(POSConnect.DEVICE_TYPE_BLUETOOTH)
    } else if (call.method == "stopScanBluetooth") {
    } else if (call.method == "connectDevice") {
    } else if (call.method == "disconnectDevice") {
    } else if (call.method == "writeCommand") {
    } else if (call.method == "initializePrinter") {
    } else if (call.method == "setMag") {
    } else if (call.method == "setAlignment") {
    } else if (call.method == "setSpeedLevel") {
    } else if (call.method == "setPageWidth") {
    } else if (call.method == "setBeepLength") {
    } else if (call.method == "drawText") {
    } else if (call.method == "drawBarcode") {
    } else if (call.method == "addBarcodeText") {
    } else if (call.method == "removeBarcodeText") {
    } else if (call.method == "drawQRCode") {
    } else if (call.method == "drawImage") {
    } else if (call.method == "drawBox") {
    } else if (call.method == "drawLine") {
    } else if (call.method == "drawInverseLine") {
    } else if (call.method == "setStringEncoding") {
    } else if (call.method == "print") {

    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
