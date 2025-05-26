class BluetoothDevice {
  final String mac;
  final String? name;

  const BluetoothDevice({required this.mac, required this.name});
}

class _PrinterDevice {
  final int code;
  final String message;
  final List<BluetoothDevice> devices;

  const _PrinterDevice({this.code = 0, this.message = "", this.devices = const []});

  factory _PrinterDevice.create(String method, dynamic args) {
    print(args);
    if (method == 'findBluetoothDevices') {
      return _PrinterDevice(code: args['code'], message: args['message']);
    } else {
      return _PrinterDevice();
    }
  }
}
