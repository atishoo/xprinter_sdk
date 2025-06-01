import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'device.dart';
import 'consts.dart';
import 'xprinter_sdk_platform_interface.dart';

/// An implementation of [XprinterSdkPlatform] that uses method channels.
class MethodChannelXprinterSdk extends XprinterSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('xprinter_sdk')..setMethodCallHandler((MethodCall call) async {
    if (call.method == "findBluetoothDevices") {
      List<BluetoothDevice> result = [];
      if ((call.arguments as String).isNotEmpty) {
        (jsonDecode(call.arguments as String) as List<dynamic>).forEach((dynamic device) {
          result.add(BluetoothDevice(mac: device['mac'] ?? '', name: device['name']));
        });
      }
      _deviceLinstener.add(result);
    }
  });

  static final StreamController<List<BluetoothDevice>> _deviceLinstener = StreamController.broadcast();

  static Stream<List<BluetoothDevice>> get deviceScanner => _deviceLinstener.stream;

  @override
  Future<void> print() {
    return methodChannel.invokeMethod<void>('print');
  }

  @override
  Future<void> setStringEncoding(XprinterChatset chatset) {
    return methodChannel.invokeMethod<void>('setStringEncoding', chatset.value);
  }

  @override
  Future<void> drawInverseLine(int x, int y, int xend, int yend, int width) {
    return methodChannel.invokeMethod<void>('drawInverseLine', {'x': x, 'y': y, 'xend': xend, 'yend': yend, 'width': width});
  }

  @override
  Future<void> drawLine(int x, int y, int xend, int yend, int thickness) {
    return methodChannel.invokeMethod<void>('drawLine', {'x': x, 'y': y, 'xend': xend, 'yend': yend, 'thickness': thickness});
  }

  @override
  Future<void> drawBox(int x, int y, int width, int height, int thickness) {
    return methodChannel.invokeMethod<void>('drawBox', {'x': x, 'y': y, 'width': width, 'height': height, 'thickness': thickness});
  }

  @override
  Future<void> drawImage(int x, int y, Uint8List image) {
    return methodChannel.invokeMethod<void>('drawImage', {'x': x, 'y': y, 'image': image});
  }

  @override
  Future<void> drawQRCode(int x, int y, String data, {XprinterQRCodeModel? codeModel, int? cellWidth}) {
    return methodChannel.invokeMethod<void>('drawQRCode', {'x': x, 'y': y, 'data': data, 'code_model': codeModel?.value, 'cell_width': cellWidth});
  }

  @override
  Future<void> removeBarcodeText() {
    return methodChannel.invokeMethod<void>('removeBarcodeText');
  }

  @override
  Future<void> addBarcodeText() {
    return methodChannel.invokeMethod<void>('addBarcodeText');
  }

  @override
  Future<void> drawBarcode(int x, int y, XprinterBarCodeType type, int height, String data, {bool vertical = false, int? width, XprinterBarcodeRatio? ratio}) {
    return methodChannel.invokeMethod<void>('drawBarcode', {'x': x, 'y': y, 'type': type.value, 'height': height, 'data': data, 'vertical': vertical, 'width': width, 'ratio': ratio?.value});
  }

  @override
  Future<void> drawText(int x, int y, String text, {XprintFont? font, XprintRotation? rotation}) async {
    return methodChannel.invokeMethod<void>('drawText', {'x': x, 'y': y, 'text': text, 'font': font, 'rotation': rotation});
  }

  @override
  Future<void> setBeepLength(int length) {
    return methodChannel.invokeMethod<void>('setBeepLength', length);
  }

  @override
  Future<void> setPageWidth(int width) {
    return methodChannel.invokeMethod<void>('setPageWidth', width);
  }

  @override
  Future<void> setSpeedLevel(int level) {
    return methodChannel.invokeMethod<void>('setSpeedLevel', level);
  }

  @override
  Future<void> setAlignment(XprinterAlignment align, [int end = -1]) {
    return methodChannel.invokeMethod<void>('setAlignment', {'align': align.index, 'end': end});
  }

  @override
  Future<void> setMag(int width, int height) {
    return methodChannel.invokeMethod<void>('setMag', {'width': width, 'height': height});
  }

  @override
  Future<void> initializePrinter({int height = 0, int offset = 0, int count = 1}) {
    return methodChannel.invokeMethod<void>('initializePrinter', {'height': height, 'offset': offset, 'count': count > 0 ? count : 1});
  }

  @override
  Future<void> writeCommand(Uint8List data) {
    return methodChannel.invokeMethod<void>('writeCommand', data);
  }

  @override
  Future<void> disconnectDevice() {
    return methodChannel.invokeMethod<void>('disconnectDevice');
  }

  @override
  Future<bool> connectDevice(String mac) async {
    bool? result = await methodChannel.invokeMethod<bool>('connectDevice', mac);
    return result == true;
  }

  @override
  Future<void> stopScanBluetooth() {
    return methodChannel.invokeMethod<void>('stopScanBluetooth');
  }

  @override
  Future<void> startScanBluetooth() {
    return methodChannel.invokeMethod<void>('startScanBluetooth');
  }
}
