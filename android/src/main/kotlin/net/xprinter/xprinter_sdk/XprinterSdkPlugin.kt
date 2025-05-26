package net.xprinter.xprinter_sdk

import android.Manifest
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.location.LocationManager
import android.os.Build
import android.provider.Settings
import com.androidisland.ezpermission.EzPermission
import com.jeremyliao.liveeventbus.LiveEventBus
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.JSONUtil
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.reactivex.rxjava3.core.Flowable
import net.posprinter.IConnectListener
import net.posprinter.IDeviceConnection
import net.posprinter.POSConnect
import org.json.JSONArray
import org.json.JSONObject
import java.util.concurrent.TimeUnit

/** XprinterSdkPlugin */
class XprinterSdkPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private val GPS_ACTION = "android.location.PROVIDERS_CHANGED"
  private lateinit var channel : MethodChannel
  private lateinit var mContext: Context

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "xprinter_sdk")
    channel.setMethodCallHandler(this)
    this.mContext = flutterPluginBinding.applicationContext
  }

  private val datas = ArrayList<BtAdapter.Bean>()
  private val bluetoothAdapter: BluetoothAdapter by lazy {
    (mContext?.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager).adapter
  }

  private fun deviceIsExist(mac: String): Boolean {
    datas.forEach {
      if (it.mac == mac) {
        return true
      }
    }
    return false
  }

  private val mBroadcastReceiver: BroadcastReceiver = object : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
      val action = intent.action
      if (BluetoothDevice.ACTION_FOUND == action) {
        val btd:BluetoothDevice?
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
          btd = intent.getParcelableExtra<BluetoothDevice>(BluetoothDevice.EXTRA_DEVICE, BluetoothDevice::class.java)
        } else {
          btd = intent.getParcelableExtra<BluetoothDevice>(BluetoothDevice.EXTRA_DEVICE)
        }
        if (btd!!.bondState != BluetoothDevice.BOND_BONDED && !deviceIsExist(btd.address)) {
          var name = btd.name
          if (name == null) name = null
          datas.add(BtAdapter.Bean(false, name, btd.address))
          val devices = JSONArray()
          datas.forEach { i ->
            run {
              val tmp = JSONObject()
              tmp.put("name", i.name)
              tmp.put("mac", i.mac)
              devices.put(tmp)
            }
          }
          channel.invokeMethod("findBluetoothDevices", devices.toString())
        }
      } else if (action == GPS_ACTION) {
        if (isGpsOpen()) {
          setBluetooth()
        }
      }
    }
  }

  private fun requestPermission() {
    val observable = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
      EzPermission.with(mContext)
        .permissions(
          Manifest.permission.ACCESS_FINE_LOCATION,
          Manifest.permission.ACCESS_COARSE_LOCATION,
          Manifest.permission.BLUETOOTH_SCAN,
          Manifest.permission.BLUETOOTH_CONNECT,
          Manifest.permission.BLUETOOTH_ADVERTISE
        )

    } else {
      EzPermission.with(mContext)
        .permissions(
          Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION
        )
    }
    observable.request { granted, denied, permanentlyDenied ->
      if (denied.isEmpty() && permanentlyDenied.isEmpty()) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M || isGpsOpen()) {
          setBluetooth()
        } else {
          openGPS()
        }
      } else {
        // todo 请求权限失败
        println("请求权限失败了")
      }
    }
  }

  private var lastTime = 0L
  private fun setBluetooth() {
    if (System.currentTimeMillis() - lastTime < 1000) {
      return
    }
    lastTime = System.currentTimeMillis()
    if (!bluetoothAdapter.isEnabled) {
      val intent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
      mContext.startActivity(intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK ))
      requestPermission()
    } else {
      searchDevices()
    }
  }

  private fun searchDevices() {
    datas.clear()
    val device: Set<BluetoothDevice> = bluetoothAdapter.bondedDevices
    device.forEach {
      val name = it.name ?: "none"
      datas.add(BtAdapter.Bean(true, name, it.address))
    }
    if (bluetoothAdapter.isDiscovering) {
      bluetoothAdapter.cancelDiscovery()
    }
    Flowable.timer(300, TimeUnit.MILLISECONDS).subscribe {
      bluetoothAdapter.startDiscovery()
    }
  }

  private fun isGpsOpen(): Boolean {
    val locationManager: LocationManager = mContext?.getSystemService(Context.LOCATION_SERVICE) as LocationManager
    val gps = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)
    val network: Boolean = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)
    return gps || network
  }

  private fun openGPS() {
    val intent = Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS)
    mContext?.startActivity(intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
  }

  var curConnect: IDeviceConnection? = null

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "startScanBluetooth") {
      val intentFilter = IntentFilter()
      intentFilter.addAction(BluetoothDevice.ACTION_FOUND)
      intentFilter.addAction(GPS_ACTION)
      mContext.registerReceiver(mBroadcastReceiver, intentFilter)
      requestPermission()
      searchDevices()
    } else if (call.method == "stopScanBluetooth") {
      mContext.unregisterReceiver(mBroadcastReceiver)
      curConnect?.close()
      result.success(true)
    } else if (call.method == "connectDevice") {
      POSConnect.init(mContext)
      curConnect?.close()
      curConnect = POSConnect.createDevice(POSConnect.DEVICE_TYPE_BLUETOOTH)
      curConnect!!.connect(call.arguments.toString()) { code, connInfo, msg ->
        when (code) {
          POSConnect.CONNECT_SUCCESS -> {
            result.success(true)
          }

          POSConnect.CONNECT_FAIL -> {
            result.success(false)
          }

          POSConnect.CONNECT_INTERRUPT -> {
            result.success(false)
          }

          POSConnect.SEND_FAIL -> {
            result.success(false)
          }

          POSConnect.USB_DETACHED -> {
          }

          POSConnect.USB_ATTACHED -> {
          }
        }
      }
    } else if (call.method == "disconnectDevice") {
    } else if (call.method == "writeCommand") {
    } else if (call.method == "initializePrinter") {
    } else if (call.method == "setMag") {
    } else if (call.method == "setAlignment") {
    } else if (call.method == "setSpeedLevel") {
    } else if (call.method == "setPageWidth") {
    } else if (call.method == "setBeepLength") {
    } else if (call.method == "drawText") {
    } else if (call.method == "drawBarcode") {
    } else if (call.method == "addBarcodeText") {
    } else if (call.method == "removeBarcodeText") {
    } else if (call.method == "drawQRCode") {
    } else if (call.method == "drawImage") {
    } else if (call.method == "drawBox") {
    } else if (call.method == "drawLine") {
    } else if (call.method == "drawInverseLine") {
    } else if (call.method == "setStringEncoding") {
    } else if (call.method == "print") {

    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
