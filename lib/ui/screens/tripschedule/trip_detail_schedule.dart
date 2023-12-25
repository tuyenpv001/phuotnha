import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:social_media/colors.dart';
import 'package:intl/intl.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/data/env/env.dart';
import 'package:social_media/domain/models/response/response_trip.dart';
import 'package:social_media/domain/services/trip_services.dart';
import 'package:social_media/ui/helpers/getBadges.dart';
import 'package:social_media/ui/screens/tripschedule/maps/map_detail.dart';
import 'package:social_media/ui/themes/button.dart';
import 'package:social_media/ui/themes/colors_theme.dart';
import 'package:social_media/ui/widgets/widgets.dart';

class TripDetailSchedulePage extends StatefulWidget {
  const TripDetailSchedulePage({super.key, required this.tripId});
final String tripId;
  @override
  State<TripDetailSchedulePage> createState() => _TripDetailSchedulePageState();
}

class _TripDetailSchedulePageState extends State<TripDetailSchedulePage> {
  late TripDetail tripDetail;
  late List<TripImage> tripImages;
  late List<TripMember> tripMembers;
  late List<TripRecommend> tripRecommends;



  @override
  Widget build(BuildContext context) {
    
    var size = MediaQuery.of(context).size;
    return Scaffold(
       backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: const TextCustom(
            text: 'Chi tiết',
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: ColorsCustom.secundary,
            isTitle: true,
          ),
          elevation: 0,
          actions: [
            Button(
            height: 40, 
            width: 40, 
            bg: bgGrey, 
            icon: const Icon(Icons.close,color: Colors.black),
             onPress: () {
                Navigator.pop(context);
              })
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical:10, horizontal: 15 ),
          child: FutureBuilder(future: tripService.getDetailExtraTripById(widget.tripId),
           builder: (context, snapshot) {
             
               if (snapshot.hasData) {
              if (snapshot.data!.trip.isNotEmpty) {
                tripDetail = snapshot.data!.trip[0];
              }
              if (snapshot.data!.tripMembers.isNotEmpty) {
                tripMembers = snapshot.data!.tripMembers;
              }
              if (snapshot.data!.tripRecommends.isNotEmpty) {
                tripRecommends = snapshot.data!.tripRecommends;
              }
              if (snapshot.data!.images.isNotEmpty) {
                tripImages = snapshot.data!.images;
              }
            }
             return  !snapshot.hasData
                  ? const Center(child: Text("Loading...")) :
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: size.height * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: bgGrey,
                                offset: const Offset(0, 5),
                                blurRadius: 5.0
                              )
                            ]
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Text(tripDetail.title, style: kTitle2Style,),
                        
                        const SizedBox(height: 10,),
                        _renderTitleInfo("Người tạo"),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      Environment.baseUrl + tripDetail.avatar
                                    ),
                                    
                                  ),
                                   const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        tripDetail.username, 
                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                                      Text(tripDetail.isLeader == 1
                                          ? "Leader"
                                          : 'Người dùng')
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                height: 50,
                                width: 50,
                                padding: const EdgeInsets.only(right: 8),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: kShadowColor.withOpacity(0.1),
                                      offset: const Offset(0, 12),
                                      blurRadius: 18.0,
                                    ),
                                  ],
                                ),
                                child: Badges.getBadgesByAchiement(tripDetail.userAchievement).isNotEmpty ? Image.asset(Badges.getBadgesByAchiement(tripDetail.userAchievement)) : null,
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 15,),
                        _renderTitleInfo("Thông tin chi tiết"),
                        const SizedBox(height: 5,),
                        _renderInforRow("Địa điểm đến", tripDetail.tripTo,isBoldValue: true),
                        const SizedBox(height: 10,),
                        _renderInforRow("Địa điểm bắt đầu", tripDetail.tripFrom, isBoldValue: true),
                        const SizedBox(
                          height: 10,
                        ),
                        _renderInforRow("Số thành viên",
                            "${tripDetail.totalMemberJoined}/ ${tripDetail.tripMember}",
                            isBoldValue: true),
                        const SizedBox(height: 10,),
                        _renderInforRow("Ngày bắt đầu", DateFormat("dd/MM/yyy")
                                .format(tripDetail.dateStart), isBoldValue: true),
                        const SizedBox(height: 10,),
                        _renderInforRow("Ngày kết thúc", DateFormat("dd/MM/yyy")
                                .format(tripDetail.dateEnd),
                            isBoldValue: true),
                        const SizedBox(height: 10,),
                        _renderInforRow("Ngày tạo", DateFormat("dd/MM/yyy")
                                .format(tripDetail.createdAt),
                            isBoldValue: true),
                   
                    
                        const SizedBox(height: 15,),
                        _renderTitleInfo("Mô tả"),
                        const SizedBox(height: 5,),
                        Text(tripDetail.description),

                        const SizedBox(height: 15,),
                         _renderTitleInfo("Hình ảnh"),
                        const SizedBox(height: 5,),


                        const SizedBox(height: 15,),
                         _renderTitleInfo("Điểm trên đường đi"),
                        const SizedBox(height: 5,),
                        MapDetail(tripRecommends: tripRecommends,),
                        const SizedBox(
                          height: 15,
                        ),
                        _renderTitleInfo("Bình luận và đánh giá"),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  );

           },),
           ),
    );
  }

  Text _renderTitleInfo(String title) {
    return Text(title, style: const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 17
    ));
  }



  Widget _renderInforRow(String title, String value,{bool isBoldValue = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
          TextCustom(
            text: "$title: ",
            fontSize: 15,
            fontWeight: isBoldValue ?  FontWeight.normal : FontWeight.w700),
        TextCustom(
          text: value,
          fontSize: 15,
          color: isBoldValue ?  textReadColor : Colors.black,
          fontWeight: !isBoldValue ? FontWeight.normal : FontWeight.w700
        ),
      ],
    );
  }

  Row _renderInforRowWithIcon(Icon icon, String title, String value,
      {bool isBoldValue = false}) {
    return Row(
      children: [
        icon,
        const SizedBox(
          width: 5,
        ),
        _renderInforRow(title, value, isBoldValue: isBoldValue),
      ],
    );
  }



  

 

}