import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:xprinter_sdk/xprinter_sdk.dart';
import 'package:xprinter_sdk/xprinter_sdk_method_channel.dart';
import 'package:xprinter_sdk/xprinter_sdk_platform_interface.dart';

class MockXprinterSdkPlatform with MockPlatformInterfaceMixin implements XprinterSdkPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final XprinterSdkPlatform initialPlatform = XprinterSdkPlatform.instance;

  test('$MethodChannelXprinterSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelXprinterSdk>());
  });

  test('getPlatformVersion', () async {
    XprinterSdk xprinterSdkPlugin = XprinterSdk();
    MockXprinterSdkPlatform fakePlatform = MockXprinterSdkPlatform();
    XprinterSdkPlatform.instance = fakePlatform;

    expect(await xprinterSdkPlugin.print(), '42');
  });
}
