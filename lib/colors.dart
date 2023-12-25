import 'dart:ui';

class ColorAssets {
   static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

 Color bgGrey = ColorAssets.fromHex('#f5f4f7');
 Color bgGreyBold = ColorAssets.fromHex('#f5f4f7');
 Color bgPrimary = ColorAssets.fromHex('#4CB9E7');
 Color bgCard = ColorAssets.fromHex('#96EFFF');
 Color bgBox = ColorAssets.fromHex('#E5D4FF');
 Color bgBox1 = ColorAssets.fromHex('#F875AA');
 Color bgBox2 = ColorAssets.fromHex('#9376E0');
 Color bgBox3 = ColorAssets.fromHex('#FFE382');
 Color bgBox4 = ColorAssets.fromHex('#F05941'); 
 Color blue400 =  ColorAssets.fromHex('#0d6efd');
 Color bluegray700 = ColorAssets.fromHex('#7c838d');
 Color bluegray400 = ColorAssets.fromHex('#bcbcbc');
 Color btnDisabled = ColorAssets.fromHex("#A4ABB6");
 Color btnJoined1 = ColorAssets.fromHex("#c5e1a5");
 Color btnJoined2 = ColorAssets.fromHex("#9ccc65");
 Color textReadColor = ColorAssets.fromHex("#263238");

