import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xprinter_sdk/xprinter_sdk_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelXprinterSdk platform = MethodChannelXprinterSdk();
  const MethodChannel channel = MethodChannel('xprinter_sdk');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });
}
