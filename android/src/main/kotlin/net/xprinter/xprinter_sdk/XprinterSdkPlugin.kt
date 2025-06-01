package net.xprinter.xprinter_sdk

import android.Manifest
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.graphics.BitmapFactory
import android.location.LocationManager
import android.os.Build
import android.provider.Settings
import com.androidisland.ezpermission.EzPermission
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.JSONUtil
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.reactivex.rxjava3.core.Flowable
import net.posprinter.CPCLConst
import net.posprinter.CPCLPrinter
import net.posprinter.IConnectListener
import net.posprinter.IDeviceConnection
import net.posprinter.POSConnect
import net.posprinter.model.AlgorithmType
import org.json.JSONArray
import org.json.JSONObject
import java.io.ByteArrayInputStream
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
  var printer: CPCLPrinter? = null

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method.equals("startScanBluetooth")) {
      val intentFilter = IntentFilter()
      intentFilter.addAction(BluetoothDevice.ACTION_FOUND)
      intentFilter.addAction(GPS_ACTION)
      mContext.registerReceiver(mBroadcastReceiver, intentFilter)
      requestPermission()
      searchDevices()
      result.success(null)
    } else if (call.method.equals("stopScanBluetooth")) {
      mContext.unregisterReceiver(mBroadcastReceiver)
      curConnect?.close()
      result.success(null)
    } else if (call.method.equals("connectDevice")) {
      POSConnect.init(mContext)
      curConnect?.close()
      curConnect = POSConnect.createDevice(POSConnect.DEVICE_TYPE_BLUETOOTH)
      curConnect!!.connect(call.arguments.toString()) { code, connInfo, msg ->
        when (code) {
          POSConnect.CONNECT_SUCCESS -> {
            printer = CPCLPrinter(curConnect)
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
    } else if (call.method.equals("disconnectDevice")) {
      curConnect?.close()
      result.success(null)
    } else if (call.method.equals("writeCommand")) {
      printer?.sendData(call.arguments as ByteArray)
      result.success(null)
    } else if (call.method.equals("initializePrinter")) {
      printer?.initializePrinter(call.argument<Int>("offset")!!, call.argument<Int>("height")!!, call.argument<Int>("count")!!)
      result.success(null)
    } else if (call.method.equals("setMag")) {
      printer?.setMag(call.argument<Int>("width")!!, call.argument<Int>("height")!!)
      result.success(null)
    } else if (call.method.equals("setAlignment")) {
      var align = CPCLConst.ALIGNMENT_LEFT
      when (call.argument<Int>("align")) {
        0 -> align = CPCLConst.ALIGNMENT_LEFT
        1 -> align = CPCLConst.ALIGNMENT_CENTER
        2 -> align = CPCLConst.ALIGNMENT_RIGHT
      }
      printer?.addAlign(align, call.argument<Int>("end")!!)
      result.success(null)
    } else if (call.method.equals("setSpeedLevel")) {
      printer?.addSpeed(call.arguments as Int)
      result.success(null)
    } else if (call.method.equals("setPageWidth")) {
      printer?.addPageWidth(call.arguments as Int)
      result.success(null)
    } else if (call.method.equals("setBeepLength")) {
      printer?.addBeep(call.arguments as Int)
      result.success(null)
    } else if (call.method.equals("drawText")) {
      var drawFont = CPCLConst.FNT_0
      when (call.argument<Int>("font")) {
        0 -> drawFont = CPCLConst.FNT_0
        1 -> drawFont = CPCLConst.FNT_1
        2 -> drawFont = CPCLConst.FNT_2
        4 -> drawFont = CPCLConst.FNT_4
        5 -> drawFont = CPCLConst.FNT_5
        6 -> drawFont = CPCLConst.FNT_6
        7 -> drawFont = CPCLConst.FNT_7
        24 -> drawFont = CPCLConst.FNT_24
        55 -> drawFont = CPCLConst.FNT_55
      }
      var drawRotation = CPCLConst.ROTATION_0
      when (call.argument<Int>("rotation")) {
        0 -> drawRotation = CPCLConst.ROTATION_0
        90 -> drawRotation = CPCLConst.ROTATION_90
        180 -> drawRotation = CPCLConst.ROTATION_180
        270 -> drawRotation = CPCLConst.ROTATION_270
      }
      printer?.addText(call.argument<Int>("x")!!, call.argument<Int>("y")!!, drawRotation, drawFont, call.argument<String>("text")!!)
      result.success(null)
    } else if (call.method.equals("drawBarcode")) {
      var x = call.argument<Int>("x")!!;
      var y = call.argument<Int>("y")!!;
      var ratio = call.argument<Int>("ratio")?:CPCLConst.BCS_RATIO_1;
      var height = call.argument<Int>("height")!!;
      var width = call.argument<Int>("width") ?: 1;
      var type = call.argument<String>("type")!!;
      var data = call.argument<String>("data")!!;
      var isVertical = call.argument<Boolean>("vertical")?:false;
      if (isVertical) {
        printer?.addBarcodeV(x, y, type, width, ratio, height, data)
      } else {
        printer?.addBarcode(x, y, type, width, ratio, height, data)
      }
      result.success(null)
    } else if (call.method.equals("addBarcodeText")) {
      printer?.addBarcodeText()
      result.success(null)
    } else if (call.method.equals("removeBarcodeText")) {
      printer?.addBarcodeTextOff()
      result.success(null)
    } else if (call.method.equals("drawQRCode")) {
      var codeModel = call.argument<Int>("code_model") ?: CPCLConst.QRCODE_MODE_ENHANCE;
      var cellWidth = call.argument<Int>("cell_width") ?: 6;
      if (cellWidth < 1 || cellWidth > 32) {
        cellWidth = 6
      }
      printer?.addQRCode(call.argument<Int>("x")!!, call.argument<Int>("y")!!, codeModel, cellWidth, call.argument<String>("data")!!)
      result.success(null)
    } else if (call.method.equals("drawImage")) {
      var bmp = BitmapFactory.decodeStream(ByteArrayInputStream(call.argument<ByteArray>("image")));
      printer?.addCGraphics(call.argument<Int>("x")!!, call.argument<Int>("y")!!, bmp.width, bmp, AlgorithmType.Dithering)
      result.success(null)
    } else if (call.method.equals("drawBox")) {
      printer?.addBox(call.argument<Int>("x")!!, call.argument<Int>("y")!!, call.argument<Int>("width")!!, call.argument<Int>("height")!!, call.argument<Int>("thickness")!!)
      result.success(null)
    } else if (call.method.equals("drawLine")) {
      printer?.addLine(call.argument<Int>("x")!!, call.argument<Int>("y")!!, call.argument<Int>("xend")!!, call.argument<Int>("yend")!!, call.argument<Int>("thickness")!!)
      result.success(null)
    } else if (call.method.equals("drawInverseLine")) {
      printer?.addInverseLine(call.argument<Int>("x")!!, call.argument<Int>("y")!!, call.argument<Int>("xend")!!, call.argument<Int>("yend")!!, call.argument<Int>("width")!!)
      result.success(null)
    } else if (call.method.equals("setStringEncoding")) {
      printer?.setCharSet(call.arguments as String)
      result.success(null)
    } else if (call.method.equals("print")) {
      printer?.addPrint()
      result.success(null)
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
