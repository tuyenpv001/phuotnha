import 'package:flutter/material.dart';
import 'package:social_media/ui/helpers/getBadges.dart';

// ignore: must_be_immutable
class Achievement extends StatelessWidget {
  Achievement(
      {super.key,
      required this.achievement,
      required this.score,
      this.height = 50,
      this.width = 50});

  final String achievement;
  final double score;
  double width;
  double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: height,
          width: width,
          padding: const EdgeInsets.only(right: 8),
          alignment: Alignment.center,
          child: Badges.getBadgesByAchiement(achievement).isNotEmpty
              ? Image.asset(Badges.getBadgesByAchiement(achievement))
              : const SizedBox(height: 0, width: 1),
        ),
        Text("$score"),
      ],
    );
  }
}
