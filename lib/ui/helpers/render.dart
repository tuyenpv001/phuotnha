

import 'package:flutter/material.dart';
import 'package:social_media/ui/widgets/widgets.dart';

class Render {
  static Row renderInforDetailTrip(String title, String detail) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextCustom(
            text: title,
            fontSize: 15,
            color: Colors.black87,
            fontWeight: FontWeight.normal),
        TextCustom(
          text: detail,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }

  
  static Row renderInfo(String title, String detail) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextCustom(
            text: title,
            fontSize: 15,
            color: Colors.black87,
            fontWeight: FontWeight.normal),
        TextCustom(
          text: detail,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}