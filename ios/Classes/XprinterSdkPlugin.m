#import "XprinterSdkPlugin.h"
#import "PrinterSDK/Headers/TSCBLEManager.h"
#import "PrinterSDK/Headers/CPCLCommand.h"

@interface XprinterSdkPlugin() <TSCBLEManagerDelegate> {
    FlutterMethodChannel *_channel;
}
@property (strong, nonatomic) TSCBLEManager *bleManager;
@property (strong, nonatomic) NSMutableArray *deviceArr;
@property (strong, nonatomic) NSMutableArray *rssiList;
@end

@implementation XprinterSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"xprinter_sdk" binaryMessenger:[registrar messenger]];
    XprinterSdkPlugin* instance = [[XprinterSdkPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"startScanBluetooth" isEqualToString:call.method]) {
      _bleManager = [TSCBLEManager sharedInstance];
      _bleManager.delegate = self;
      [_bleManager startScan];
      result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"stopScanBluetooth" isEqualToString:call.method]) {
      [_bleManager stopScan];
  } else if ([@"connectDevice" isEqualToString:call.method]) {
      [_bleManager connectDevice:self.deviceArr[0]];
  } else if ([@"disconnectDevice" isEqualToString:call.method]) {
      [_bleManager disconnectRootPeripheral];
      [_bleManager stopScan];
  } else if ([@"writeCommand" isEqualToString:call.method]) {
      [_bleManager writeCommandWithData:nil];
  } else if ([@"initializePrinter" isEqualToString:call.method]) {
  } else if ([@"setMag" isEqualToString:call.method]) {
      [CPCLCommand initLabelWithHeight:23];
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

#pragma mark - POSBLEManagerDelegate

// 更新蓝牙列表
- (void)TSCbleUpdatePeripheralList:(NSArray *)peripherals RSSIList:(NSArray *)rssiList {
    _deviceArr = [NSMutableArray arrayWithArray:peripherals];
    _rssiList = [NSMutableArray arrayWithArray:rssiList];
    // 可以发送给客户端
}

// 连接成功
- (void)TSCbleConnectPeripheral:(CBPeripheral *)peripheral {
    // 这里是连接成功，可以给客户端发送消息
}

// 连接失败
- (void)TSCbleFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    [_channel invokeMethod:@"connect" arguments:@"aasd"];
}

// 断开连接
- (void)TSCbleDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
}

@end
