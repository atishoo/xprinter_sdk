import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'device.dart';
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
  Future<String?> print1() async {
    final version = await methodChannel.invokeMethod<String>('print');
    return version;
  }

  @override
  Future<String?> setStringEncoding(String chatset) async {
    final version = await methodChannel.invokeMethod<String>('setStringEncoding');
    return version;
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
  Future<String?> removeBarcodeText() async {
    final version = await methodChannel.invokeMethod<String>('removeBarcodeText');
    return version;
  }

  @override
  Future<String?> addBarcodeText() async {
    final version = await methodChannel.invokeMethod<String>('addBarcodeText');
    return version;
  }

  @override
  Future<String?> drawBarcode(int x, int y, String type, int height, String data, {bool vertical = false, int? width, int? ratio}) async {
    final version = await methodChannel.invokeMethod<String>('drawBarcode');
    return version;
  }

  @override
  Future<String?> drawText(int x, int y, String text, {String? font, String? rotation}) async {
    final version = await methodChannel.invokeMethod<String>('drawText');
    return version;
  }

  @override
  Future<String?> setBeepLength(int length) async {
    final version = await methodChannel.invokeMethod<String>('setBeepLength');
    return version;
  }

  @override
  Future<String?> setPageWidth(int width) async {
    final version = await methodChannel.invokeMethod<String>('setPageWidth');
    return version;
  }

  @override
  Future<String?> setSpeedLevel(int level) async {
    final version = await methodChannel.invokeMethod<String>('setSpeedLevel');
    return version;
  }

  @override
  Future<String?> setAlignment(int align, {int? end}) async {
    final version = await methodChannel.invokeMethod<String>('setAlignment');
    return version;
  }

  @override
  Future<String?> setMag(int width, int height) async {
    final version = await methodChannel.invokeMethod<String>('setMag');
    return version;
  }

  @override
  Future<void> initializePrinter({int height = 0, int offset = 0, int count = 1}) {
    return methodChannel.invokeMethod<void>('initializePrinter', {'height': height, 'offset': Offset, 'count': count > 0 ? count : 1});
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
