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

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
