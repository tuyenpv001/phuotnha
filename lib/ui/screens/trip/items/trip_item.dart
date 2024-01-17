import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/colors.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/domain/blocs/blocs.dart';
import 'package:social_media/ui/widgets/widgets.dart';
import 'package:intl/intl.dart';

import '../../../../data/env/env.dart';

class TripItem extends StatelessWidget {
  const TripItem({
    super.key,
     required this.title, required this.totalMemberJoined, required this.description, required this.tripUid, required this.createdAt, required this.dateStart, required this.dateEnd, required this.username, required this.avatar, required this.images, required this.tripMember, required this.isClose, required this.isJoined, required this.isLeader, required this.tripFrom, required this.tripTo, required this.isOwner,required this.score
  });


  final String title;
  final String description;
  final String tripFrom;
  final String tripTo;
  final String tripUid;
  final DateTime createdAt;
  final DateTime dateStart;
  final DateTime dateEnd;
  final String username;
  final String avatar;
  final String images;
  final int tripMember;
  final int totalMemberJoined;
  final int isClose;
  final int isJoined;
  final int isOwner;
  final int isLeader;
  final double score;

   String _getNameBtn() {
    if(totalMemberJoined == tripMember) return "Đã đóng";
    if(isJoined != 0) return "Đã tham gia";
    if (isOwner != 0) return "Bắt đầu";
    if (isClose != 0 && isOwner == 0){
      if (isJoined != 0) {
        return "Đã tham gia";
      } else {
        return "Đã đóng";
      }
    }
    return "Tham gia";
  }
  @override
  Widget build(BuildContext context) {
    final tripBloc = BlocProvider.of<TripBloc>(context);
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      constraints: const BoxConstraints(
        minHeight: 350,
      ),
      width: size.width * 0.95,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 10),
              blurRadius: 20,
            )
          ],
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Stack(
        children: [
          Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(Environment.baseUrl + avatar)
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: kTitle2Style,
                        ),
                        Text(
                          isLeader != 0  ? "Leader" : "Member",
                          style: kBodyLabelStyle,
                        )
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    gradient: _getColorButton(),
                  ),
                  child: InkWell(
                    onTap: () {
                      if(totalMemberJoined == tripMember) return;
                        if (isJoined != 0) {
                          tripBloc.add(OnJoinTrip(tripUid, 'cancel'));
                        } else {
                          tripBloc.add(OnJoinTrip(tripUid, 'join'));
                        }
                    },
                    child: TextCustom(
                        text: _getNameBtn(), 
                        color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: size.width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const TextCustom(
                          text: "Địa điểm: ",
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                      TextCustom(
                        text: tripTo,
                        fontSize: 15,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const TextCustom(
                          text: "Thời gian: ",
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                      TextCustom(
                        text: "${DateFormat.yMd().format(dateStart)} - ${DateFormat.yMd().format(dateEnd)}",
                        fontSize: 15,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const TextCustom(
                          text: "Số thành viên: ",
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                      TextCustom(
                        text: " $totalMemberJoined /$tripMember",
                        fontSize: 15,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    children: [
                      Text(
                        description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.justify,
                      ),
                      // TextButton(
                      //     onPressed: () {
                         
                      //     },
                      //     style: const ButtonStyle(
                      //       padding: MaterialStatePropertyAll(EdgeInsets.all(0)),
                      //       backgroundColor:
                      //           MaterialStatePropertyAll(Colors.transparent),
                      //     ),
                      //     clipBehavior: Clip.none,
                      //     child: const Text("Chi tiết")),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // Container Image
            Container(
                  height: 185,
                  width: double.maxFinite,
                  alignment: Alignment.topRight,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: NetworkImage(Environment.baseUrl+ images), fit: BoxFit.cover)
                  ),
            )
          ],
        ),
          Positioned(
            right: 10,
            top: 45,
            child: Container(
              width: 60,
              height: 80,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: AssetImage('assets/img/score.png'),
                )
              ),
              child: Text('$score',
              style: const TextStyle(
                backgroundColor: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.amberAccent
              ),)),
          )
        ]
      ),
    );
  }


  LinearGradient _getColorButton() {
    if(totalMemberJoined == tripMember) {
      return LinearGradient(
        colors: [
          ColorTheme.bluegray400,
          ColorTheme.btnDisabled,
        ],
      );
    }
    if(isClose != 0 && isOwner != 0) {
      return LinearGradient(
        colors: [
        ColorTheme.bluegray400,
        ColorTheme.btnDisabled,
        ],
      );
    }

    return const LinearGradient(
        colors: [
          Color(0xFF73A0F4),
          Color(0xFF4A47F5),
    ],);
  }
}


