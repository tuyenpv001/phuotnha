import 'package:flutter/material.dart';

class BtnCircle extends StatelessWidget {
  const BtnCircle(
      {super.key, this.child, this.gradient, this.radius, this.onTap});
  final Widget? child;
  final Gradient? gradient;
  final double? radius;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 30)),
          gradient: gradient ??
              const LinearGradient(
                colors: [
                  Color(0xFF73A0F4),
                  Color(0xFF4A47F5),
                ],
              ),
        ),
        child: child ??
            const Icon(Icons.bookmark_add_outlined, color: Colors.white),
      ),
    );
  }
}
