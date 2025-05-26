import 'dart:io';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

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

  Future<String?> startScanBluetooth() {
    throw UnimplementedError('startScanBluetooth() has not been implemented.');
  }

  Future<String?> stopScanBluetooth() {
    throw UnimplementedError('stopScanBluetooth() has not been implemented.');
  }

  Future<bool?> connectDevice(String mac) {
    throw UnimplementedError('connectDevice() has not been implemented.');
  }

  Future<String?> disconnectDevice() {
    throw UnimplementedError('disconnectDevice() has not been implemented.');
  }

  Future<String?> writeCommand() {
    throw UnimplementedError('writeCommand() has not been implemented.');
  }

  Future<String?> initializePrinter({int height = 0, int offset = 0, int count = 1}) {
    throw UnimplementedError('initializePrinter() has not been implemented.');
  }

  Future<String?> setMag(int width, int height) {
    throw UnimplementedError('setMag() has not been implemented.');
  }

  Future<String?> setAlignment(int align, {int? end}) {
    throw UnimplementedError('setAlignment() has not been implemented.');
  }

  Future<String?> setSpeedLevel(int level) {
    throw UnimplementedError('setSpeedLevel() has not been implemented.');
  }

  Future<String?> setPageWidth(int width) {
    throw UnimplementedError('setPageWidth() has not been implemented.');
  }

  Future<String?> setBeepLength(int length) {
    throw UnimplementedError('setBeepLength() has not been implemented.');
  }

  Future<String?> drawText(int x, int y, String text, {String? font, String? rotation}) {
    throw UnimplementedError('drawText() has not been implemented.');
  }

  Future<String?> drawBarcode(int x, int y, String type, int height, String data, {bool vertical = false, int? width, int? ratio}) {
    throw UnimplementedError('drawBarcode() has not been implemented.');
  }

  Future<String?> addBarcodeText() {
    throw UnimplementedError('addBarcodeText() has not been implemented.');
  }

  Future<String?> removeBarcodeText() {
    throw UnimplementedError('removeBarcodeText() has not been implemented.');
  }

  Future<String?> drawQRCode(int x, int y, String data, {int? codeModel, int? cellWidth}) {
    throw UnimplementedError('drawQRCode() has not been implemented.');
  }

  Future<String?> drawImage(int x, int y, File image) {
    throw UnimplementedError('drawImage() has not been implemented.');
  }

  Future<String?> drawBox(int x, int y, int width, int height, int thickness) {
    throw UnimplementedError('drawBox() has not been implemented.');
  }

  Future<String?> drawLine(int x, int y, int xend, int yend, int thickness) {
    throw UnimplementedError('drawLine() has not been implemented.');
  }

  Future<String?> drawInverseLine(int x, int y, int xend, int yend, int width) {
    throw UnimplementedError('drawInverseLine() has not been implemented.');
  }

  Future<String?> setStringEncoding(String chatset) {
    throw UnimplementedError('setStringEncoding() has not been implemented.');
  }

  Future<String?> print() {
    throw UnimplementedError('print() has not been implemented.');
  }
}
