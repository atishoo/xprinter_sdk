#import "XprinterSdkPlugin.h"
#import "TSCBLEManager.h"
#import "CPCLCommand.h"
#import <objc/runtime.h>

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
    [instance setup];
    [registrar addMethodCallDelegate:instance channel:channel];
    
}

#pragma mark - lazy
- (NSMutableArray *)deviceArr {
    if (!_deviceArr) {
        _deviceArr = [NSMutableArray array];
    }
    return _deviceArr;
}

- (void) setup {
    if (self.bleManager == nil) {
        self.bleManager = [TSCBLEManager sharedInstance];
        self.bleManager.delegate = self;
        NSLog(@"✅ [setup] self: %@", self);
        NSLog(@"✅ [setup] delegate 设置后: %@", self.bleManager.delegate);
        NSLog(@"✅ [setup] bleManager 实例: %@", self.bleManager);
    }
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
//    if (self.bleManager == nil) {
//        NSLog(@"我滴妈，进来了");
//        self.bleManager = [TSCBLEManager sharedInstance];
//        self.bleManager.delegate = self;
//        NSLog(@"✅ [setup] delegate 设置后xxx: %@", self.bleManager.delegate);
//    }
  if ([@"startScanBluetooth" isEqualToString:call.method]) {
      NSLog(@"✅ [setup] delegate 设置后: %@", self.bleManager.delegate);
      
      [self.bleManager startScan];
      
      NSLog(@"今天没吃饭吗");
      
      result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"stopScanBluetooth" isEqualToString:call.method]) {
      [self.bleManager stopScan];
  } else if ([@"connectDevice" isEqualToString:call.method]) {
      [self.bleManager connectDevice:self.deviceArr[0]];
  } else if ([@"disconnectDevice" isEqualToString:call.method]) {
      [self.bleManager disconnectRootPeripheral];
      [self.bleManager stopScan];
  } else if ([@"writeCommand" isEqualToString:call.method]) {
      [self.bleManager writeCommandWithData:nil];
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
- (void)TSCbleUpdatePeripheralList:(NSArray *)peripherals RSSIList:(NSArray *)rssiList{
    NSLog(@"xxxxx======66666");
    _deviceArr = [NSMutableArray arrayWithArray:peripherals];
    _rssiList = [NSMutableArray arrayWithArray:rssiList];
    // 可以发送给客户端
    NSLog(@"吃了吃了");
    NSLog(@"设备数组内容: %@", self.deviceArr);
    NSLog(@"设备数组内容:");
    for (id device in self.deviceArr) {
        NSLog(@"%@", device);
    }
    NSLog(@"吃完了");
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
