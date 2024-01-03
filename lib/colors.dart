import 'dart:ui';

class ColorAssets {
   static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

class ColorTheme {

  static Color bgPrimary = ColorAssets.fromHex('#4CB9E7');
  static Color bgDanger = ColorAssets.fromHex('#f73378');
  static Color bgGrey = ColorAssets.fromHex('#f5f4f7');
  static Color bgGreyBold = ColorAssets.fromHex('#f5f4f7');
  static Color bgCard = ColorAssets.fromHex('#96EFFF');
  static Color bgBox = ColorAssets.fromHex('#E5D4FF');
  static Color bgBox1 = ColorAssets.fromHex('#F875AA');
  static Color bgBox2 = ColorAssets.fromHex('#9376E0');
  static Color bgBox3 = ColorAssets.fromHex('#FFE382');
  static Color bgBox4 = ColorAssets.fromHex('#F05941');
  static Color blue400 = ColorAssets.fromHex('#0d6efd');
  static Color bluegray700 = ColorAssets.fromHex('#7c838d');
  static Color bluegray400 = ColorAssets.fromHex('#bcbcbc');
  static Color btnDisabled = ColorAssets.fromHex("#A4ABB6");
  static Color btnJoined1 = ColorAssets.fromHex("#c5e1a5");
  static Color btnJoined2 = ColorAssets.fromHex("#9ccc65");
  static Color textReadColor = ColorAssets.fromHex("#263238");

}


