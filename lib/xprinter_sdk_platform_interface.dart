import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'consts.dart';
import 'xprinter_sdk_method_channel.dart';

abstract class XprinterSdkPlatform extends PlatformInterface {
  /// Constructs a XprinterSdkPlatform.
  XprinterSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static XprinterSdkPlatform _instance = MethodChannelXprinterSdk();

  /// The default instance of [XprinterSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelXprinterSdk].
  static XprinterSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [XprinterSdkPlatform] when
  /// they register themselves.
  static set instance(XprinterSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> startScanBluetooth() {
    throw UnimplementedError('startScanBluetooth() has not been implemented.');
  }

  Future<void> stopScanBluetooth() {
    throw UnimplementedError('stopScanBluetooth() has not been implemented.');
  }

  Future<bool> connectDevice(String mac) {
    throw UnimplementedError('connectDevice() has not been implemented.');
  }

  Future<void> disconnectDevice() {
    throw UnimplementedError('disconnectDevice() has not been implemented.');
  }

  Future<void> writeCommand(Uint8List data) {
    throw UnimplementedError('writeCommand() has not been implemented.');
  }

  Future<void> initializePrinter({int height = 0, int offset = 0, int count = 1}) {
    throw UnimplementedError('initializePrinter() has not been implemented.');
  }

  Future<void> setMag(int width, int height) {
    throw UnimplementedError('setMag() has not been implemented.');
  }

  Future<void> setAlignment(XprinterAlignment align, [int end = -1]) {
    throw UnimplementedError('setAlignment() has not been implemented.');
  }

  Future<void> setSpeedLevel(int level) {
    throw UnimplementedError('setSpeedLevel() has not been implemented.');
  }

  Future<void> setPageWidth(int width) {
    throw UnimplementedError('setPageWidth() has not been implemented.');
  }

  Future<void> setBeepLength(int length) {
    throw UnimplementedError('setBeepLength() has not been implemented.');
  }

  Future<void> drawText(int x, int y, String text, {XprintFont? font, XprintRotation? rotation}) {
    throw UnimplementedError('drawText() has not been implemented.');
  }

  Future<void> drawBarcode(int x, int y, XprinterBarCodeType type, int height, String data, {bool vertical = false, int? width, XprinterBarcodeRatio? ratio}) {
    throw UnimplementedError('drawBarcode() has not been implemented.');
  }

  Future<void> addBarcodeText() {
    throw UnimplementedError('addBarcodeText() has not been implemented.');
  }

  Future<void> removeBarcodeText() {
    throw UnimplementedError('removeBarcodeText() has not been implemented.');
  }

  Future<void> drawQRCode(int x, int y, String data, {XprinterQRCodeModel? codeModel, int? cellWidth}) {
    throw UnimplementedError('drawQRCode() has not been implemented.');
  }

  Future<void> drawImage(int x, int y, Uint8List image) {
    throw UnimplementedError('drawImage() has not been implemented.');
  }

  Future<void> drawBox(int x, int y, int width, int height, int thickness) {
    throw UnimplementedError('drawBox() has not been implemented.');
  }

  Future<void> drawLine(int x, int y, int xend, int yend, int thickness) {
    throw UnimplementedError('drawLine() has not been implemented.');
  }

  Future<void> drawInverseLine(int x, int y, int xend, int yend, int width) {
    throw UnimplementedError('drawInverseLine() has not been implemented.');
  }

  Future<void> setStringEncoding(XprinterChatset chatset) {
    throw UnimplementedError('setStringEncoding() has not been implemented.');
  }

  Future<void> print() {
    throw UnimplementedError('print() has not been implemented.');
  }
}
