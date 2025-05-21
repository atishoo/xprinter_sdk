import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'xprinter_sdk_platform_interface.dart';

/// An implementation of [XprinterSdkPlatform] that uses method channels.
class MethodChannelXprinterSdk extends XprinterSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('xprinter_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
