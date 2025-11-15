#import "XprinterSdkPlugin.h"

#if TARGET_OS_SIMULATOR

@implementation XprinterSdkPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel =
        [FlutterMethodChannel methodChannelWithName:@"xprinter_sdk"
                                    binaryMessenger:[registrar messenger]];
    XprinterSdkPlugin* instance = [[XprinterSdkPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    // 模拟器下统一提示不可用（你也可以区分方法单独处理）
    result([FlutterError errorWithCode:@"UNAVAILABLE_ON_SIMULATOR"
                               message:@"xprinter_sdk only supports running on physical devices, please debug on a real device."
                               details:nil]);
}

@end

#else

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

# pragma mark - 初始化class
- (void) setup:(FlutterMethodChannel *) channel {
    _channel = channel;
    if (self.bleManager == nil) {
        self.bleManager = [TSCBLEManager sharedInstance];
        self.bleManager.delegate = self;
    }
}

# pragma mark - 方法映射
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"startScanBluetooth" isEqualToString:call.method]) {
      [self.bleManager startScan];
      result(nil);
  } else if ([@"stopScanBluetooth" isEqualToString:call.method]) {
      [self.bleManager stopScan];
      result(nil);
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
      result(nil);
  } else if ([@"writeCommand" isEqualToString:call.method]) {
      FlutterStandardTypedData *data = call.arguments;
      [self.bleManager writeCommandWithData:data.data];
      result(nil);
  } else if ([@"initializePrinter" isEqualToString:call.method]) {
      self.dataM = [[NSMutableData alloc] init];
      [CPCLCommand setStringEncoding: CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
      [self.dataM appendData:[CPCLCommand initLabelWithHeight: [(NSNumber*)call.arguments[@"height"] intValue] count: [(NSNumber*)call.arguments[@"count"] intValue] offsetx: [(NSNumber*)call.arguments[@"offset"] intValue]]];
      result(nil);
  } else if ([@"setMag" isEqualToString:call.method]) {
      [self.dataM appendData:[CPCLCommand setmagWithw:[(NSNumber*)call.arguments[@"width"] intValue] h:[(NSNumber*)call.arguments[@"height"] intValue]]];
      result(nil);
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
      result(nil);
  } else if ([@"setSpeedLevel" isEqualToString:call.method]) {
      [self.dataM appendData:[CPCLCommand setSpeedLevel: [(NSNumber *)call.arguments intValue]]];
      result(nil);
  } else if ([@"setPageWidth" isEqualToString:call.method]) {
      [self.dataM appendData:[CPCLCommand setPageWidth: [(NSNumber *)call.arguments intValue]]];
      result(nil);
  } else if ([@"setBeepLength" isEqualToString:call.method]) {
      [self.dataM appendData:[CPCLCommand setBeepLength:[(NSNumber *)call.arguments intValue]]];
      result(nil);
  } else if ([@"drawText" isEqualToString:call.method]) {
      NSDictionary < NSString * , id > *args = (NSDictionary < NSString * , id > *)call.arguments;
      NSNumber* x = (NSNumber*) args[@"x"];
      NSNumber* y = (NSNumber*) args[@"y"];
      NSString* text = (NSString*) args[@"text"];
      CPCLFont drawFont = FNT_0;
      if (args[@"font"] != [NSNull null]) {
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
      }
      CPCLRotation drawRotation = ROTA_0;
      if (args[@"rotation"] != [NSNull null]) {
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
      }
      [self.dataM appendData:[CPCLCommand drawTextWithx:x.intValue y:y.intValue rotation:drawRotation font:drawFont content:text]];
      result(nil);
  } else if ([@"drawBarcode" isEqualToString:call.method]) {
      NSDictionary < NSString * , id > *args = (NSDictionary < NSString * , id > *)call.arguments;
      NSNumber* x = (NSNumber*) args[@"x"];
      NSNumber* y = (NSNumber*) args[@"y"];
      NSNumber* height = (NSNumber*) args[@"height"];
      NSNumber* width = (NSNumber*) args[@"width"];
      if ([width isEqual:[NSNull null]]) {
          width = @(1);
      }
      NSNumber* ratio = (NSNumber*) args[@"ratio"];
      NSString* type = (NSString*) args[@"type"];
      NSString* data = (NSString*) args[@"data"];
      NSNumber* isVertical = (NSNumber *) args[@"vertical"];

      CPCLBarCode codeType = BC_128;
      if ([type isEqual:@"128"]) {
          codeType = BC_128;
      } else if ([type isEqual:@"UPCA"]) {
          codeType = BC_UPCA;
      } else if ([type isEqual:@"UPCE"]) {
          codeType = BC_UPCE;
      } else if ([type isEqual:@"EAN13"]) {
          codeType = BC_EAN13;
      } else if ([type isEqual:@"EAN8"]) {
          codeType = BC_EAN8;
      } else if ([type isEqual:@"39"]) {
          codeType = BC_39;
      } else if ([type isEqual:@"93"]) {
          codeType = BC_93;
      } else if ([type isEqual:@"CODABAR"]) {
          codeType = BC_CODABAR;
      }
      CPCLBarCodeRatio ratioType = BCR_RATIO_1;
      if (![ratio isEqual:[NSNull null]]) {
          ratioType = (CPCLBarCodeRatio)ratio.intValue;
      }

      if (isVertical.boolValue) {
          [self.dataM appendData:[CPCLCommand drawBarcodeVerticalWithx:x.intValue y:y.intValue codeType:codeType height:height.intValue ratio:ratioType content:data]];
      } else {
          [self.dataM appendData:[CPCLCommand drawBarcodeWithx:x.intValue y:y.intValue codeType:codeType height:height.intValue ratio:ratioType content:data]];
      }
      result(nil);
  } else if ([@"addBarcodeText" isEqualToString:call.method]) {
      [self.dataM appendData: [CPCLCommand barcodeText: 0]];
      result(nil);
  } else if ([@"removeBarcodeText" isEqualToString:call.method]) {
      [self.dataM appendData: [CPCLCommand barcodeTextOff]];
      result(nil);
  } else if ([@"drawQRCode" isEqualToString:call.method]) {
      NSDictionary < NSString * , id > *args = (NSDictionary < NSString * , id > *)call.arguments;
      NSNumber* x = (NSNumber*) args[@"x"];
      NSNumber* y = (NSNumber*) args[@"y"];
      NSNumber* codeModel = (NSNumber*) args[@"code_model"];
      NSNumber* cellWidth = (NSNumber*) args[@"cell_width"];
      NSString* data = (NSString*) args[@"data"];
      CPCLQRCodeMode codeModelType = CODE_MODE_ENHANCE;
      if ([codeModel isEqual:[NSNull null]]) {
          codeModelType = CODE_MODE_ENHANCE;
      } else {
          codeModelType = (CPCLQRCodeMode)codeModel;
      }
      if ([cellWidth isEqual:[NSNull null]]) {
          cellWidth = @(6);
      } else if (cellWidth.intValue < 1 || cellWidth.intValue > 32) {
          cellWidth = @(6);
      }
      [self.dataM appendData:[CPCLCommand drawQRCodeWithx:x.intValue y:y.intValue codeModel:codeModelType cellWidth:cellWidth.intValue content:data]];
      result(nil);
  } else if ([@"drawImage" isEqualToString:call.method]) {
      NSDictionary < NSString * , id > *args = (NSDictionary < NSString * , id > *)call.arguments;
      NSNumber* x = (NSNumber*) args[@"x"];
      NSNumber* y = (NSNumber*) args[@"y"];
      FlutterStandardTypedData *imageData = call.arguments[@"image"];
      [self.dataM appendData:[CPCLCommand drawImageWithx:x.intValue y:y.intValue image:[UIImage imageWithData: imageData.data]]];
      result(nil);
  } else if ([@"drawBox" isEqualToString:call.method]) {
      NSDictionary < NSString * , id > *args = (NSDictionary < NSString * , id > *)call.arguments;
      NSNumber* x = (NSNumber*) args[@"x"];
      NSNumber* y = (NSNumber*) args[@"y"];
      NSNumber* width = (NSNumber*) args[@"width"];
      NSNumber* height = (NSNumber*) args[@"height"];
      NSNumber* thickness = (NSNumber*) args[@"thickness"];
      [self.dataM appendData:[CPCLCommand drawBoxWithx:x.intValue y:y.intValue width:width.intValue height:height.intValue thickness:thickness.intValue]];
      result(nil);
  } else if ([@"drawLine" isEqualToString:call.method]) {
      NSDictionary < NSString * , id > *args = (NSDictionary < NSString * , id > *)call.arguments;
      NSNumber* x = (NSNumber*) args[@"x"];
      NSNumber* y = (NSNumber*) args[@"y"];
      NSNumber* xend = (NSNumber*) args[@"xend"];
      NSNumber* yend = (NSNumber*) args[@"yend"];
      NSNumber* thickness = (NSNumber*) args[@"thickness"];
      [self.dataM appendData:[CPCLCommand drawLineWithx:x.intValue y:y.intValue xend:xend.intValue yend:yend.intValue width:thickness.intValue]];
      result(nil);
  } else if ([@"drawInverseLine" isEqualToString:call.method]) {
      NSDictionary < NSString * , id > *args = (NSDictionary < NSString * , id > *)call.arguments;
      NSNumber* x = (NSNumber*) args[@"x"];
      NSNumber* y = (NSNumber*) args[@"y"];
      NSNumber* xend = (NSNumber*) args[@"xend"];
      NSNumber* yend = (NSNumber*) args[@"yend"];
      NSNumber* width = (NSNumber*) args[@"width"];
      [self.dataM appendData:[CPCLCommand drawInverseLineWithx:x.intValue y:y.intValue xend:xend.intValue yend:yend.intValue width:width.intValue]];
      result(nil);
  } else if ([@"setStringEncoding" isEqualToString:call.method]) {
      NSString *argCharset = (NSString *)call.arguments;
      NSStringEncoding chatset = NSUTF8StringEncoding;
      if ([argCharset isEqual:@"GBK"]) {
          chatset = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
      } else if ([argCharset isEqual:@"UTF-8"]) {
          chatset = NSUTF8StringEncoding;
      } else if ([argCharset isEqual:@"UTF-16"]) {
          chatset = NSUTF16StringEncoding;
      } else if ([argCharset isEqual:@"UTF-16BE"]) {
          chatset = NSUTF16BigEndianStringEncoding;
      } else if ([argCharset isEqual:@"UTF-16LE"]) {
          chatset = NSUTF16LittleEndianStringEncoding;
      } else if ([argCharset isEqual:@"ISO-8859-1"]) {
          chatset = NSISOLatin1StringEncoding;
      } else if ([argCharset isEqual:@"US-ASCII"]) {
          chatset = NSASCIIStringEncoding;
      }
      [CPCLCommand setStringEncoding:chatset];
      result(nil);
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
      result(nil);
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
#endif