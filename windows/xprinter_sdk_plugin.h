#ifndef FLUTTER_PLUGIN_XPRINTER_SDK_PLUGIN_H_
#define FLUTTER_PLUGIN_XPRINTER_SDK_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace xprinter_sdk {

class XprinterSdkPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  XprinterSdkPlugin();

  virtual ~XprinterSdkPlugin();

  // Disallow copy and assign.
  XprinterSdkPlugin(const XprinterSdkPlugin&) = delete;
  XprinterSdkPlugin& operator=(const XprinterSdkPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace xprinter_sdk

#endif  // FLUTTER_PLUGIN_XPRINTER_SDK_PLUGIN_H_
