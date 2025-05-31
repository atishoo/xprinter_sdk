#import <Flutter/Flutter.h>
#import "TSCBLEManager.h"

@interface XprinterSdkPlugin : NSObject<FlutterPlugin, TSCBLEManagerDelegate>

- (void)TSCbleUpdatePeripheralList:(NSArray *)peripherals RSSIList:(NSArray *)rssiList;

- (void)TSCbleConnectPeripheral:(CBPeripheral *)peripheral;

- (void)TSCbleFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;

- (void)TSCbleDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;

@end
