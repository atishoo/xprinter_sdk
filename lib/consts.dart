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
