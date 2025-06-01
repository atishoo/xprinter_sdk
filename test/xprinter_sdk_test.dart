import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:xprinter_sdk/consts.dart';
import 'package:xprinter_sdk/xprinter_sdk_method_channel.dart';
import 'package:xprinter_sdk/xprinter_sdk_platform_interface.dart';

class MockXprinterSdkPlatform with MockPlatformInterfaceMixin implements XprinterSdkPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> addBarcodeText() {
    // TODO: implement addBarcodeText
    throw UnimplementedError();
  }

  @override
  Future<bool> connectDevice(String mac) {
    // TODO: implement connectDevice
    throw UnimplementedError();
  }

  @override
  Future<void> disconnectDevice() {
    // TODO: implement disconnectDevice
    throw UnimplementedError();
  }

  @override
  Future<void> drawBarcode(int x, int y, XprinterBarCodeType type, int height, String data, {bool vertical = false, int? width, XprinterBarcodeRatio? ratio}) {
    // TODO: implement drawBarcode
    throw UnimplementedError();
  }

  @override
  Future<void> drawBox(int x, int y, int width, int height, int thickness) {
    // TODO: implement drawBox
    throw UnimplementedError();
  }

  @override
  Future<void> drawImage(int x, int y, Uint8List image) {
    // TODO: implement drawImage
    throw UnimplementedError();
  }

  @override
  Future<void> drawInverseLine(int x, int y, int xend, int yend, int width) {
    // TODO: implement drawInverseLine
    throw UnimplementedError();
  }

  @override
  Future<void> drawLine(int x, int y, int xend, int yend, int thickness) {
    // TODO: implement drawLine
    throw UnimplementedError();
  }

  @override
  Future<void> drawQRCode(int x, int y, String data, {XprinterQRCodeModel? codeModel, int? cellWidth}) {
    // TODO: implement drawQRCode
    throw UnimplementedError();
  }

  @override
  Future<void> drawText(int x, int y, String text, {XprintFont? font, XprintRotation? rotation}) {
    // TODO: implement drawText
    throw UnimplementedError();
  }

  @override
  Future<void> initializePrinter({int height = 0, int offset = 0, int count = 1}) {
    // TODO: implement initializePrinter
    throw UnimplementedError();
  }

  @override
  Future<void> print() {
    // TODO: implement print
    throw UnimplementedError();
  }

  @override
  Future<void> removeBarcodeText() {
    // TODO: implement removeBarcodeText
    throw UnimplementedError();
  }

  @override
  Future<void> setAlignment(XprinterAlignment align, [int end = -1]) {
    // TODO: implement setAlignment
    throw UnimplementedError();
  }

  @override
  Future<void> setBeepLength(int length) {
    // TODO: implement setBeepLength
    throw UnimplementedError();
  }

  @override
  Future<void> setMag(int width, int height) {
    // TODO: implement setMag
    throw UnimplementedError();
  }

  @override
  Future<void> setPageWidth(int width) {
    // TODO: implement setPageWidth
    throw UnimplementedError();
  }

  @override
  Future<void> setSpeedLevel(int level) {
    // TODO: implement setSpeedLevel
    throw UnimplementedError();
  }

  @override
  Future<void> setStringEncoding(XprinterChatset chatset) {
    // TODO: implement setStringEncoding
    throw UnimplementedError();
  }

  @override
  Future<void> startScanBluetooth() {
    // TODO: implement startScanBluetooth
    throw UnimplementedError();
  }

  @override
  Future<void> stopScanBluetooth() {
    // TODO: implement stopScanBluetooth
    throw UnimplementedError();
  }

  @override
  Future<void> writeCommand(Uint8List data) {
    // TODO: implement writeCommand
    throw UnimplementedError();
  }
}

void main() {
  final XprinterSdkPlatform initialPlatform = XprinterSdkPlatform.instance;

  test('$MethodChannelXprinterSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelXprinterSdk>());
  });

  test('getPlatformVersion', () async {
    MockXprinterSdkPlatform fakePlatform = MockXprinterSdkPlatform();
    XprinterSdkPlatform.instance = fakePlatform;
  });
}
