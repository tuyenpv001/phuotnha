import 'package:flutter/material.dart';
import 'package:social_media/ui/themes/colors_theme.dart';
import 'package:social_media/ui/widgets/widgets.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        TextCustom(text: 'Phuot',
         fontWeight: FontWeight.w600,
        fontSize: 22,
        color: ColorsCustom.primary,
         isTitle: true,),
        TextCustom(text: 'nha.',
         fontWeight: FontWeight.w600,
        fontSize: 22,
        color: ColorsCustom.background,
         isTitle: true,),
      ],
    );
  }
}