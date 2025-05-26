#import "XprinterSdkPlugin.h"
#import "PrinterSDK/Headers/POSBLEManager.h"

@interface XprinterSdkPlugin() <POSBLEManagerDelegate> {
    FlutterMethodChannel *_channel;
}
@end

@implementation XprinterSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"xprinter_sdk" binaryMessenger:[registrar messenger]];
  XprinterSdkPlugin* instance = [[XprinterSdkPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"startScanBluetooth" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"stopScanBluetooth" isEqualToString:call.method]) {
  } else if ([@"connectDevice" isEqualToString:call.method]) {
  } else if ([@"disconnectDevice" isEqualToString:call.method]) {
  } else if ([@"writeCommand" isEqualToString:call.method]) {
  } else if ([@"initializePrinter" isEqualToString:call.method]) {
  } else if ([@"setMag" isEqualToString:call.method]) {
  } else if ([@"setAlignment" isEqualToString:call.method]) {
  } else if ([@"setSpeedLevel" isEqualToString:call.method]) {
  } else if ([@"setPageWidth" isEqualToString:call.method]) {
  } else if ([@"setBeepLength" isEqualToString:call.method]) {
  } else if ([@"drawText" isEqualToString:call.method]) {
  } else if ([@"drawBarcode" isEqualToString:call.method]) {
  } else if ([@"addBarcodeText" isEqualToString:call.method]) {
  } else if ([@"removeBarcodeText" isEqualToString:call.method]) {
  } else if ([@"drawQRCode" isEqualToString:call.method]) {
  } else if ([@"drawImage" isEqualToString:call.method]) {
  } else if ([@"drawBox" isEqualToString:call.method]) {
  } else if ([@"drawLine" isEqualToString:call.method]) {
  } else if ([@"drawInverseLine" isEqualToString:call.method]) {
  } else if ([@"setStringEncoding" isEqualToString:call.method]) {
  } else if ([@"print" isEqualToString:call.method]) {
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
