import 'package:flutter/material.dart';
import 'package:social_media/data/env/env.dart';

class ImageContainer extends StatelessWidget {
  const ImageContainer({
    super.key,
    required this.size,
    required this.imgUrl,
  });

  final Size size;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: size.width * 0.95,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(Environment.baseUrl + imgUrl))),
    );
  }
}
