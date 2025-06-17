# Xprinter_SDK

XPrinter's Flutter version SDK

## Getting Started

### For Android

These need to be added to the project file ```android/build.gradle```
```
allprojects {
    repositories {
        google()
        mavenCentral()
+       maven {
+           url "${project(':aar').projectDir}/build"  // for build.gradle
+           url = uri(project(":xprinter_sdk").projectDir.resolve("mvn")) // for build.gradle.kts
+       }
+       maven { url 'https://jitpack.io' }
    }
}
```

## Use printer

### Start scanner
```dart
XprinterSdk printer = XprinterSdk();
printer.startScanBluetooth();
```

### Listen stream to display devices
```dart
void listenDevices(List<BluetoothDevice> devices) {
  // your code
}
XprinterSdk.deviceScanner.listen(listenDevices);
```
or use StreamBuilder
```dart
StreamBuilder(
    stream: XprinterSdk.deviceScanner,
    initialData: <BluetoothDevice>[],
    builder: (BuildContext context, AsyncSnapshot<List<BluetoothDevice>> snapshot) {
      return YouWidget();
    }
)
```

### Connect device

```dart
bool result = await printer.connectDevice(mac);
```

### Print
```dart
printer.initializePrinter(height: 30, offset: 0, count: 1);

// Your print content
printer.drawText(0, 0, 'some text', font: XprinterFontTypes.FONT_5);
printer.drawBarcode(0, 18, XprinterBarCodeType.BC_128, 8, '1234567890');
// ... and more code

// Finally, start print
printer.print();
```

### Disconnect device
```dart
printer.disconnectDevice();
```