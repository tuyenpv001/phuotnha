import 'package:flutter/material.dart';

class BtnTripDetail extends StatelessWidget {
  const BtnTripDetail({
    super.key,
    required this.child,
    this.onTap,
  });

  final void Function()? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF73A0F4),
              Color(0xFF4A47F5),
            ],
          ),
        ),
        child: child,
      ),
    );
  }
}
