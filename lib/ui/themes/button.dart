import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final double height;
  final double width;
  final Color bg;
  final Icon icon;
  final Function onPress;
  final double? padding;

  const Button({super.key, required this.height, required this.width, required this.bg, required this.icon,required this.onPress, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding ?? 8.0),
      child: Container(
              height: height,
              width: width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(50)),
              child:  IconButton(
                  splashRadius: 20,
                  onPressed: () {
                    onPress();
                  },
                  icon: icon,)
      ),
    );
  }

  
}