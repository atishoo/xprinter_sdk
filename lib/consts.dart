enum XprinterAlignment { ALIGNMENT_LEFT, ALIGNMENT_CENTER, ALIGNMENT_RIGHT }

typedef XprintFont = int;

class XprinterFontTypes {
  static const XprintFont FONT_0 = 0;
  static const XprintFont FONT_1 = 1;
  static const XprintFont FONT_2 = 2;
  static const XprintFont FONT_3 = 3;
  static const XprintFont FONT_4 = 4;
  static const XprintFont FONT_5 = 5;
  static const XprintFont FONT_6 = 6;
  static const XprintFont FONT_7 = 7;
  static const XprintFont FONT_24 = 24;
  static const XprintFont FONT_55 = 55;
}

typedef XprintRotation = int;

class XprinterRotationTypes {
  static const XprintRotation ROTATION_0 = 0;
  static const XprintRotation ROTATION_90 = 90;
  static const XprintRotation ROTATION_180 = 180;
  static const XprintRotation ROTATION_270 = 270;
}

enum XprinterChatset {
  GBK('GBK'),
  UTF_8('UTF-8'),
  UTF_16('UTF-16'),
  UTF_16BE('UTF-16BE'),
  UTF_16LE('UTF-16LE'),
  ISO_8859_1('ISO-8859-1'),
  US_ASCII('US-ASCII');

  final String value;
  const XprinterChatset(this.value);
}

enum XprinterBarCodeType {
  BC_128('128'),
  BC_UPCA('UPCA'),
  BC_UPCE('UPCE'),
  BCS_EAN13('EAN13'),
  BCS_EAN8('EAN8'),
  BCS_39('39'),
  BCS_93('93'),
  BCS_CODABAR('CODABAR');

  final String value;
  const XprinterBarCodeType(this.value);
}

enum XprinterBarcodeRatio {
  RATIO_0(0),
  RATIO_1(1),
  RATIO_2(2),
  RATIO_3(3),
  RATIO_4(4),
  RATIO_20(20),
  RATIO_21(21),
  RATIO_22(22),
  RATIO_23(23),
  RATIO_24(24),
  RATIO_25(25),
  RATIO_26(26),
  RATIO_27(27),
  RATIO_28(28),
  RATIO_29(29),
  RATIO_30(30);

  final int value;
  const XprinterBarcodeRatio(this.value);
}

enum XprinterQRCodeModel {
  CODE_MODE_ORG(1),
  CODE_MODE_ENHANCE(2);

  final int value;
  const XprinterQRCodeModel(this.value);
}
