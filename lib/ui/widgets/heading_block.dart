

import 'package:flutter/material.dart';
import 'package:social_media/constants.dart';

class HeadingBlock extends StatelessWidget {
  
  const HeadingBlock({super.key, this.title, this.subTile});
  final String? title;
  final String? subTile;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title",
          style: kTitle2Style,
        ),
        Text(
          "$subTile",
          style: kSubtitleStyle,
        ),
      ],
    );
  }
}