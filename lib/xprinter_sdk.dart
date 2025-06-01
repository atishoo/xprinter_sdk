import 'dart:io';

import 'consts.dart';
import 'xprinter_sdk_method_channel.dart';

import 'device.dart';
import 'xprinter_sdk_platform_interface.dart';

class XprinterSdk {
  static const String BARCODE_TYPE_BCS_128 = 'BCS_128'; // Code 128
  static const String BARCODE_TYPE_BCS_UPCA = 'BCS_UPCA'; // UPC-A
  static const String BARCODE_TYPE_BCS_UPCE = 'BCS_UPCE'; // UPC-E
  static const String BARCODE_TYPE_BCS_EAN13 = 'BCS_EAN13'; // EAN/JAN-13
  static const String BARCODE_TYPE_BCS_EAN8 = 'BCS_EAN8'; // EAN/JAN-8
  static const String BARCODE_TYPE_BCS_39 = 'BCS_39'; // Code 39
  static const String BARCODE_TYPE_BCS_93 = 'BCS_93'; // Code 93/Ext.93
  static const String BARCODE_TYPE_BCS_CODABAR = 'BCS_CODABAR'; // Codabar

  static const int BARCODE_RATIO_0 = 0; // 1.5:1
  static const int BARCODE_RATIO_1 = 0; // 2.0:1
  static const int BARCODE_RATIO_2 = 0; // 2.5:1
  static const int BARCODE_RATIO_3 = 0; // 3.0:1
  static const int BARCODE_RATIO_4 = 0; // 3.5:1
  static const int BARCODE_RATIO_20 = 0; // 2.0:1
  static const int BARCODE_RATIO_21 = 0; // 2.1:1
  static const int BARCODE_RATIO_22 = 0; // 2.2:1
  static const int BARCODE_RATIO_23 = 0; // 2.3:1
  static const int BARCODE_RATIO_24 = 0; // 2.4:1
  static const int BARCODE_RATIO_25 = 0; // 2.5:1
  static const int BARCODE_RATIO_26 = 0; // 2.6:1
  static const int BARCODE_RATIO_27 = 0; // 2.7:1
  static const int BARCODE_RATIO_28 = 0; // 2.8:1
  static const int BARCODE_RATIO_29 = 0; // 2.9:1
  static const int BARCODE_RATIO_30 = 0; // 3.0:1

  static const int QRCODE_MODE_ORG = 0; // 原始规范
  static const int QRCODE_MODE_ENHANCE = 0; // 增强后的规范

  static Stream<List<BluetoothDevice>> get deviceScanner => MethodChannelXprinterSdk.deviceScanner;

  int _calcPointFromMm(double mm) {
    return (mm / 25.4 * 203).round();
  }

  // ******** 连接设备 ****** //
  Future<void> startScanBluetooth() {
    return XprinterSdkPlatform.instance.startScanBluetooth();
  }

  Future<void> stopScanBluetooth() {
    return XprinterSdkPlatform.instance.stopScanBluetooth();
  }

  Future<bool> connectDevice(String mac) {
    return XprinterSdkPlatform.instance.connectDevice(mac);
  }

  Future<void> disconnectDevice() {
    return XprinterSdkPlatform.instance.disconnectDevice();
  }

  Future<String?> writeCommand() {
    return XprinterSdkPlatform.instance.writeCommand();
  }
  // ******** 连接设备 END ****** //

  // ******** 打印部分 ****** //
  /**
   * #### 初始化打印对象
   * 初始化成功后，就会使用这个对象进行打印
   * ###### 参数说明
   * - [height] 标签最大高度，单位mm
   * - [offset] x轴偏移位置，单位mm
   * - [count] 要打印的标签数量，默认为1
   */
  Future<void> initializePrinter({double height = 0, double offset = 0, int count = 1}) {
    return XprinterSdkPlatform.instance.initializePrinter(height: _calcPointFromMm(height), offset: _calcPointFromMm(offset), count: count);
  }

  /**
   * #### 设置字体放大倍数
   * 将常驻字体放大指定倍数
   * ###### 参数说明
   * - [width] 宽度放大倍数。有效放大倍数区间为 **_1~16_**
   * - [height] 高度放大倍数。有效放大倍数区间为 **_1~16_**
   */
  Future<void> setMag(int width, int height) {
    return XprinterSdkPlatform.instance.setMag(width, height);
  }

  /**
   * #### 设置字段对齐方式
   * 默认情况下，打印机将左对齐所有字段。对齐命令将对所有后续字段保持有效，直至制定了其他对齐命令。
   * ###### 参数说明
   * - [align] 对齐方式，[XprinterAlignment.ALIGNMENT_LEFT]、[XprinterAlignment.ALIGNMENT_CENTER]、[XprinterAlignment.ALIGNMENT_RIGHT]
   * - [end] 对齐的结束点
   */
  Future<void> setAlignment(XprinterAlignment align, [int end = -1]) {
    return XprinterSdkPlatform.instance.setAlignment(align, end);
  }

  /**
   * #### 设置打印速度
   * 0~5 级设置打印速度
   * ###### 参数说明
   * - [level] 打印速度，**_0~5_**
   */
  Future<void> setSpeedLevel(int level) {
    return XprinterSdkPlatform.instance.setSpeedLevel(level);
  }

  /**
   * #### 设置打印宽度
   * 设置打印的宽度
   * ###### 参数说明
   * - [width] 设置打印宽度，单位mm
   */
  Future<void> setPageWidth(double width) {
    return XprinterSdkPlatform.instance.setPageWidth(_calcPointFromMm(width));
  }

  /**
   * #### 设置蜂鸣发出时间
   * 此方法用于让打印机蜂鸣器发出给定时间长度的声音，未配备蜂鸣器的打印机将忽略此方法
   * ###### 参数说明
   * - [length] 蜂鸣长度，以1/8秒为单位，比如16的length表示发声时间为2秒
   */
  Future<void> setBeepLength(int length) {
    return XprinterSdkPlatform.instance.setBeepLength(length);
  }

  /**
   * #### 绘制文本内容
   * 文本打印
   * ###### 参数说明
   * - [x] 文本起始的x值
   * - [y] 文本起始的y值
   * - [text] 文本内容
   * - [font] 文本的字体类型：
   *   - [XprinterFontTypes.FONT_0]
   *   - [XprinterFontTypes.FONT_1]
   *   - [XprinterFontTypes.FONT_2]
   *   - [XprinterFontTypes.FONT_3]
   *   - [XprinterFontTypes.FONT_4]
   *   - [XprinterFontTypes.FONT_5]
   *   - [XprinterFontTypes.FONT_6]
   *   - [XprinterFontTypes.FONT_7]
   *   - [XprinterFontTypes.FONT_24]
   *   - [XprinterFontTypes.FONT_55]
   * - [rotation] 顺时针旋转角度：
   *   - [XprinterRotationTypes.ROTATION_0]
   *   - [XprinterRotationTypes.ROTATION_90]
   *   - [XprinterRotationTypes.ROTATION_180]
   *   - [XprinterRotationTypes.ROTATION_270]
   */
  Future<void> drawText(int x, int y, String text, {XprintFont? font, XprintRotation? rotation}) {
    return XprinterSdkPlatform.instance.drawText(x, y, text, font: font, rotation: rotation);
  }

  /**
   * #### 绘制条形码
   * 绘制条形码
   * ###### 参数说明
   * - [x] 条码起始点横坐标，单位为点
   * - [y] 条码起始点纵坐标，单位为点
   * - [type] 条码类型：
   *   - [XprinterSdk.BARCODE_TYPE_BCS_128]
   *   - [XprinterSdk.BARCODE_TYPE_BCS_UPCA]
   *   - [XprinterSdk.BARCODE_TYPE_BCS_UPCE]
   *   - [XprinterSdk.BARCODE_TYPE_BCS_EAN13]
   *   - [XprinterSdk.BARCODE_TYPE_BCS_EAN8]
   *   - [XprinterSdk.BARCODE_TYPE_BCS_39]
   *   - [XprinterSdk.BARCODE_TYPE_BCS_93]
   *   - [XprinterSdk.BARCODE_TYPE_BCS_CODABAR]
   * - [height] 条码的单位高度。
   * - [data] 条码的数据。
   * - [ratio] 宽条与窄条的比率，默认为BCS_RATIO_1：
   *   - [XprinterSdk.BARCODE_RATIO_0]
   *   - [XprinterSdk.BARCODE_RATIO_1]
   *   - [XprinterSdk.BARCODE_RATIO_2]
   *   - [XprinterSdk.BARCODE_RATIO_3]
   *   - [XprinterSdk.BARCODE_RATIO_4]
   *   - [XprinterSdk.BARCODE_RATIO_20]
   *   - [XprinterSdk.BARCODE_RATIO_21]
   *   - [XprinterSdk.BARCODE_RATIO_22]
   *   - [XprinterSdk.BARCODE_RATIO_23]
   *   - [XprinterSdk.BARCODE_RATIO_24]
   *   - [XprinterSdk.BARCODE_RATIO_25]
   *   - [XprinterSdk.BARCODE_RATIO_26]
   *   - [XprinterSdk.BARCODE_RATIO_27]
   *   - [XprinterSdk.BARCODE_RATIO_28]
   *   - [XprinterSdk.BARCODE_RATIO_29]
   *   - [XprinterSdk.BARCODE_RATIO_30]
   * - [width] 窄条的单位宽度，默认为1。
   * - [vertical] 是否纵向。
   */
  Future<String?> drawBarcode(int x, int y, String type, int height, String data, {bool vertical = false, int? width, int? ratio}) {
    return XprinterSdkPlatform.instance.drawBarcode(x, y, type, height, data);
  }

  /**
   * #### 添加条码注释
   * 添加条码注释
   */
  Future<String?> addBarcodeText() {
    return XprinterSdkPlatform.instance.addBarcodeText();
  }

  /**
   * #### 取消条码注释
   * 取消条码注释
   */
  Future<String?> removeBarcodeText() {
    return XprinterSdkPlatform.instance.removeBarcodeText();
  }

  /**
   * #### 绘制二维码
   * 绘制二维码
   * ###### 参数说明
   * - [x] 二维码起始点横坐标，单位为点
   * - [y] 二维码起始点纵坐标，单位为点
   * - [data] 二维码的数据。
   * - [codeModel] 二维码规范编码，默认为QRCODE_MODE_ENHANCE：
   *   - [XprinterSdk.QRCODE_MODE_ORG]
   *   - [XprinterSdk.QRCODE_MODE_ENHANCE]
   * - [cellWidth] 单元格大小，范围：[[1,32]]，默认为6。
   */
  Future<String?> drawQRCode(int x, int y, String data, {int? codeModel, int? cellWidth}) {
    return XprinterSdkPlatform.instance.drawQRCode(x, y, data);
  }

  /**
   * #### 绘制图片
   * 绘制图片
   * ###### 参数说明
   * - [x] 图片起始点横坐标，单位为点
   * - [y] 图片起始点纵坐标，单位为点
   * - [image] 图片对象
   */
  Future<String?> drawImage(int x, int y, File image) {
    return XprinterSdkPlatform.instance.drawImage(x, y, image);
  }

  /**
   * #### 绘制矩形
   * 绘制矩形
   * ###### 参数说明
   * - [x] 矩形起始点横坐标，单位为点
   * - [y] 矩形起始点纵坐标，单位为点
   * - [width] 矩形宽度，单位为点
   * - [height] 矩形高度，单位为点
   * - [thickness] 矩形线条宽度
   */
  Future<String?> drawBox(int x, int y, int width, int height, int thickness) {
    return XprinterSdkPlatform.instance.drawBox(x, y, width, height, thickness);
  }

  /**
   * #### 绘制线条
   * 绘制线条
   * ###### 参数说明
   * - [x] 线条起始点横坐标，单位为点
   * - [y] 线条起始点纵坐标，单位为点
   * - [xend] 线条结束横坐标，单位为点
   * - [yend] 线条结束纵坐标，单位为点
   * - [thickness] 线条宽度
   */
  Future<String?> drawLine(int x, int y, int xend, int yend, int thickness) {
    return XprinterSdkPlatform.instance.drawLine(x, y, xend, yend, thickness);
  }

  /**
   * #### 指定区域的数据黑白反向显示
   * 将指定区域的数据黑白反向显示
   * ###### 参数说明
   * - [x] 反显区域起始点横坐标，单位为点
   * - [y] 反显区域起始点纵坐标，单位为点
   * - [xend] 反显区域结束横坐标，单位为点
   * - [yend] 反显区域结束纵坐标，单位为点
   * - [width] 反显区域宽度，单位为点
   */
  Future<String?> drawInverseLine(int x, int y, int xend, int yend, int width) {
    return XprinterSdkPlatform.instance.drawInverseLine(x, y, xend, yend, width);
  }

  /**
   * #### 设置字符编码
   * 设置将打印内容传输给打印机所采用的字符编码，默认编码为gbk
   * ###### 参数说明
   * - [chatset] 打印机所能识别的字符编码类型，没有默认值，参考 [XprinterChatset] 的枚举值
   */
  Future<void> setStringEncoding(XprinterChatset chatset) {
    return XprinterSdkPlatform.instance.setStringEncoding(chatset);
  }

  /**
   * #### 结束命令，启动打印机
   * 整个命令集的结束命令，将会启动文件打印
   */
  Future<void> print() {
    return XprinterSdkPlatform.instance.print();
  }

  // ******** 打印部分 END ****** //
}
