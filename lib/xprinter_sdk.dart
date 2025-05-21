
import 'xprinter_sdk_platform_interface.dart';

class XprinterSdk {
  Future<String?> getPlatformVersion() {
    return XprinterSdkPlatform.instance.getPlatformVersion();
  }
}
