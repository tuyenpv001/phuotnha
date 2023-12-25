import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final String name;


  const Label({required this.name,super.key});

  @override
  Widget build(BuildContext context) {
      return  Padding(
        padding:const EdgeInsets.only(left: 20),
        child: Text(
          name,
          textAlign: TextAlign.start,
        ),
      );
  }
}