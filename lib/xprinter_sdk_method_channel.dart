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

  static StreamController<List<BluetoothDevice>> _deviceLinstener = StreamController.broadcast();

  static Stream<List<BluetoothDevice>> get deviceScanner => _deviceLinstener.stream;

  @override
  Future<void> print() {
    return methodChannel.invokeMethod<void>('print');
  }

  @override
  Future<void> setStringEncoding(XprinterChatset chatset) {
    return methodChannel.invokeMethod<String>('setStringEncoding', chatset.value);
  }

  @override
  Future<String?> drawInverseLine(int x, int y, int xend, int yend, int width) async {
    final version = await methodChannel.invokeMethod<String>('drawInverseLine');
    return version;
  }

  @override
  Future<String?> drawLine(int x, int y, int xend, int yend, int thickness) async {
    final version = await methodChannel.invokeMethod<String>('drawLine');
    return version;
  }

  @override
  Future<String?> drawBox(int x, int y, int width, int height, int thickness) async {
    final version = await methodChannel.invokeMethod<String>('drawBox');
    return version;
  }

  @override
  Future<String?> drawImage(int x, int y, File image) async {
    final version = await methodChannel.invokeMethod<String>('drawImage');
    return version;
  }

  @override
  Future<String?> drawQRCode(int x, int y, String data, {int? codeModel, int? cellWidth}) async {
    final version = await methodChannel.invokeMethod<String>('drawQRCode');
    return version;
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
  Future<String?> drawBarcode(int x, int y, String type, int height, String data, {bool vertical = false, int? width, int? ratio}) async {
    final version = await methodChannel.invokeMethod<String>('drawBarcode');
    return version;
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
  Future<String?> writeCommand() async {
    final version = await methodChannel.invokeMethod<String>('writeCommand');
    return version;
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
