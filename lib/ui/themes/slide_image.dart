import 'package:flutter/material.dart';
import 'package:social_media/colors.dart';
import 'package:social_media/data/env/env.dart';
import 'package:social_media/domain/models/response/response_trip.dart';

class SlideImage extends StatefulWidget {
  const SlideImage({
    super.key,
    required this.size,
    required this.tripImages,
  });

  final Size size;
  final List<TripImage> tripImages;

  @override
  State<SlideImage> createState() => _SlideImageState();
}

class _SlideImageState extends State<SlideImage> {
  int i = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: widget.size.height * 0.3,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      Environment.baseUrl + widget.tripImages[i].tripImgUrl),
                  fit: BoxFit.fill),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                    color: ColorTheme.bgGrey,
                    offset: const Offset(0, 5),
                    blurRadius: 5.0)
              ]),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 120,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.tripImages.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    i = index;
                  });
                },
                child: Container(
                  height: 100,
                  width: widget.size.width * 0.5,
                  margin: EdgeInsets.only(
                      right: index + 1 == widget.tripImages.length ? 0 : 10),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(Environment.baseUrl +
                              widget.tripImages[index].tripImgUrl),
                          fit: BoxFit.fill),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                            color: ColorTheme.bgGrey,
                            offset: const Offset(0, 5),
                            blurRadius: 5.0)
                      ]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
