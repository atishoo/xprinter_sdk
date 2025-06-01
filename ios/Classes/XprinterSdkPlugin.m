#import "XprinterSdkPlugin.h"
#import "TSCBLEManager.h"
#import "CPCLCommand.h"

@interface XprinterSdkPlugin() <TSCBLEManagerDelegate> {
    FlutterMethodChannel *_channel;
}
@property (strong, nonatomic) TSCBLEManager *bleManager;
@property (strong, nonatomic) NSMutableArray *deviceArr;
@property (strong, nonatomic) NSMutableArray *rssiList;
@property (strong, nonatomic) NSMutableData *dataM;
@end


@implementation XprinterSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"xprinter_sdk" binaryMessenger:[registrar messenger]];
    XprinterSdkPlugin* instance = [[XprinterSdkPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    [instance setup:channel];
}

#pragma mark - lazy
- (NSMutableArray *)deviceArr {
    if (!_deviceArr) {
        _deviceArr = [NSMutableArray array];
    }
    return _deviceArr;
}

- (void) setup:(FlutterMethodChannel *) channel {
    _channel = channel;
    if (self.bleManager == nil) {
        self.bleManager = [TSCBLEManager sharedInstance];
        self.bleManager.delegate = self;
    }
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"startScanBluetooth" isEqualToString:call.method]) {
      [self.bleManager startScan];
//      result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"stopScanBluetooth" isEqualToString:call.method]) {
      [self.bleManager stopScan];
  } else if ([@"connectDevice" isEqualToString:call.method]) {
      bool ok = false;
      for (CBPeripheral *peripheral in self.deviceArr) {
          // 创建字典并添加到数组
          if ([[call.arguments stringValue] isEqualToString:peripheral.identifier.UUIDString]) {
              [self.bleManager connectDevice:peripheral];
              ok = true;
              break;
          }
      }
      result(@(ok));
  } else if ([@"disconnectDevice" isEqualToString:call.method]) {
      [self.bleManager disconnectRootPeripheral];
      [self.bleManager stopScan];
  } else if ([@"writeCommand" isEqualToString:call.method]) {
      [self.bleManager writeCommandWithData:nil];
  } else if ([@"initializePrinter" isEqualToString:call.method]) {
      self.dataM = [[NSMutableData alloc] init];
      NSLog(@([(NSNumber*)call.arguments[@"height"] intValue]));
      NSLog(@([(NSNumber*)call.arguments[@"offset"] intValue]));
      NSLog(@([(NSNumber*)call.arguments[@"count"] intValue]));
      [self.dataM appendData:[CPCLCommand initLabelWithHeight: [(NSNumber*)call.arguments[@"height"] intValue] count: [(NSNumber*)call.arguments[@"count"] intValue] offsetx: [(NSNumber*)call.arguments[@"offset"] intValue]]];
  } else if ([@"setMag" isEqualToString:call.method]) {
      [self.dataM appendData:[CPCLCommand setmagWithw:[(NSNumber*)call.arguments[@"width"] intValue] h:[(NSNumber*)call.arguments[@"height"] intValue]]];
  } else if ([@"setAlignment" isEqualToString:call.method]) {
      NSDictionary < NSString * , id > *args = (NSDictionary < NSString * , id > *)call.arguments;
      NSNumber* align = (NSNumber*) args[@"align"];
      CPCLAlignment alignment = ALIGNMENT_LEFT;
      if ([align isEqual:@(0)]) {
          alignment = ALIGNMENT_LEFT;
      } else if ([align isEqual:@(1)]) {
          alignment = ALIGNMENT_CENTER;
      } else if ([align isEqual:@(2)]) {
          alignment = ALIGNMENT_RIGHT;
      }
      NSNumber* end = (NSNumber*) args[@"end"];
      if ([end isEqual:@(-1)]) {
          [self.dataM appendData:[CPCLCommand setAlignment:alignment]];
      } else {
          [self.dataM appendData:[CPCLCommand setAlignment:alignment end:end.intValue]];
      }
  } else if ([@"setSpeedLevel" isEqualToString:call.method]) {
      [self.dataM appendData:[CPCLCommand setSpeedLevel: [(NSNumber *)call.arguments intValue]]];
  } else if ([@"setPageWidth" isEqualToString:call.method]) {
      [self.dataM appendData:[CPCLCommand setPageWidth:[(NSNumber *)call.arguments intValue]]];
  } else if ([@"setBeepLength" isEqualToString:call.method]) {
      [self.dataM appendData:[CPCLCommand setBeepLength:[(NSNumber *)call.arguments intValue]]];
  } else if ([@"drawText" isEqualToString:call.method]) {
      NSDictionary < NSString * , id > *args = (NSDictionary < NSString * , id > *)call.arguments;
      NSNumber* x = (NSNumber*) args[@"x"];
      NSNumber* y = (NSNumber*) args[@"y"];
      NSString* text = (NSString*) args[@"text"];
      CPCLFont drawFont = FNT_0;
      switch ([(NSNumber*) args[@"font"] intValue]) {
          case 0:
              drawFont = FNT_0;
              break;
          case 1:
              drawFont = FNT_1;
              break;
          case 2:
              drawFont = FNT_2;
              break;
          case 3:
              drawFont = FNT_3;
              break;
          case 4:
              drawFont = FNT_4;
              break;
          case 5:
              drawFont = FNT_5;
              break;
          case 6:
              drawFont = FNT_6;
              break;
          case 7:
              drawFont = FNT_7;
              break;
          case 24:
              drawFont = FNT_24;
              break;
          case 55:
              drawFont = FNT_55;
              break;
              
          default:
              break;
      }
      CPCLRotation drawRotation = ROTA_0;
      switch ([(NSNumber*) args[@"rotation"] intValue]) {
          case 0:
              drawRotation = ROTA_0;
              break;
          case 90:
              drawRotation = ROTA_90;
              break;
          case 180:
              drawRotation = ROTA_180;
              break;
          case 270:
              drawRotation = ROTA_270;
              break;
              
          default:
              break;
      }
      [self.dataM appendData:[CPCLCommand drawTextWithx:x.intValue y:y.intValue rotation:drawRotation font:drawFont content:text]];
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
      [self.dataM appendData:[CPCLCommand form]];
      [self.dataM appendData:[CPCLCommand print]];
      [self.bleManager writeCommandWithData:self.dataM writeCallBack:^(CBCharacteristic *characteristic, NSError *error) {
                if (error) {
                    NSLog(@"❌报错了！%@", error);
                    return;
                }
      }];
      [self.dataM setLength:0];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

#pragma mark - POSBLEManagerDelegate

// 更新蓝牙列表
- (void)TSCbleUpdatePeripheralList:(NSArray *)peripherals RSSIList:(NSArray *)rssiList{
    _deviceArr = [NSMutableArray arrayWithArray:peripherals];
    _rssiList = [NSMutableArray arrayWithArray:rssiList];
    // 可以发送给客户端
    NSMutableArray *deviceInfoArray = [NSMutableArray array];

    for (CBPeripheral *peripheral in self.deviceArr) {
        // 创建字典并添加到数组
        [deviceInfoArray addObject:@{
            @"name": peripheral.name ?: nil,
            @"mac": peripheral.identifier.UUIDString
        }];
    }
    
    // 2. 转换为 JSON 数据
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:deviceInfoArray options:NSJSONWritingSortedKeys error:&error];
    
    [_channel invokeMethod:@"findBluetoothDevices" arguments:error ? @"" : [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
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
