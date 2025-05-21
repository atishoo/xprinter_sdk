#include "include/xprinter_sdk/xprinter_sdk_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "xprinter_sdk_plugin.h"

void XprinterSdkPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  xprinter_sdk::XprinterSdkPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
