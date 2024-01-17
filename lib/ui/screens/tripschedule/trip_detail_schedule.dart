import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media/colors.dart';
import 'package:intl/intl.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/data/env/env.dart';
import 'package:social_media/domain/blocs/trip/trip_bloc.dart';
import 'package:social_media/domain/models/response/response_comment_trip.dart';
import 'package:social_media/domain/models/response/response_trip.dart';
import 'package:social_media/domain/services/trip_services.dart';
import 'package:social_media/ui/helpers/error_message.dart';
import 'package:social_media/ui/helpers/getBadges.dart';
import 'package:social_media/ui/helpers/modal_loading_short.dart';
import 'package:social_media/ui/screens/tripschedule/maps/map_detail.dart';
import 'package:social_media/ui/themes/button.dart';
import 'package:social_media/ui/themes/colors_theme.dart';
import 'package:social_media/ui/themes/slide_image.dart';
import 'package:social_media/ui/widgets/achivement.dart';
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
  late List<TripComment> tripComments;
  late TextEditingController _commentController;
  late TextEditingController _rateController;

@override
  void initState() {
     _commentController = TextEditingController();
     _rateController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
     _commentController.clear();
    _commentController.dispose();
     _rateController.clear();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     final tripBloc = BlocProvider.of<TripBloc>(context);
    var size = MediaQuery.of(context).size;
    return BlocListener<TripBloc, TripState>(
      listener: (context, state) {
        if (state is LoadingSaveTrip || state is LoadingTrip) {
          modalLoadingShort(context);
        } else if (state is FailureTrip) {
          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        } else if (state is SuccessTrip) {
          Navigator.pop(context);
          setState(() {});
        }
      },
    child: Scaffold(
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
            bg: ColorTheme.bgGrey, 
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
              // if (snapshot.data!.tripComments.isNotEmpty) {
              //   tripComments = snapshot.data!.tripComments;
              // }
              if (snapshot.data!.images.isNotEmpty) {
                tripImages = snapshot.data!.images;
              }
            }
             return  !snapshot.hasData
                  ? const Center(child: Text("Loading...")) :
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      SingleChildScrollView(
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SlideImage(size: size, tripImages: tripImages),
                            
                          const SizedBox(height: 20,),
                          Text(tripDetail.title, style: kTitle2Style,),
                          
                          const SizedBox(height: 10,),
                          _renderTitleInfo("Người tạo"),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tripDetail.username, 
                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                                      Text(tripDetail.isLeader == 1
                                          ? "Leader"
                                          : 'Member')
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                height: 70,
                                width: 70,
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
                          
                          const SizedBox(height: 20,),
                          _renderTitleInfo("Thông tin chi tiết"),
                          const SizedBox(height: 10,),
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
                                         
                                          
                          const SizedBox(height: 20,),
                          _renderTitleInfo("Mô tả"),
                          const SizedBox(height: 10,),
                          Text(tripDetail.description),
                            
                          const SizedBox(height: 20,),
                           _renderTitleInfo("Điểm trên đường đi"),
                          const SizedBox(height: 10,),
                          MapDetail(tripRecommends: tripRecommends,),
                          const SizedBox(
                            height: 20,
                          ),
                          _renderTitleInfo("Bình luận và đánh giá"),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: size.height * 0.75,
                            child: FutureBuilder(
                              future: tripService.getCommentsByUidTripCompleted(widget.tripId),
                              builder:(context, snapshot) {
                                if(snapshot.hasData) {
                                  tripComments = snapshot.data!;
                                }
                                return !snapshot.hasData ? const Text("Chưa có bình luận nào") : ListView.builder(
                                itemCount: snapshot.data!.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 60,
                                            decoration:
                                                BoxDecoration(
                                              borderRadius:
                                                  BorderRadius
                                                      .circular(50),
                                              image: DecorationImage(
                                                  image: NetworkImage(Environment
                                                          .baseUrl +
                                                      tripComments[
                                                              index]
                                                          .avatar)),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                            children: [
                                              Text(
                                                  tripComments[index]
                                                      .fullname + ' /Số điểm: ${tripComments[index].tripRate}',
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight
                                                              .w600)),
                                              Text(tripComments[index]
                                                  .tripComment),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Achievement(achievement: tripComments[index].achievement, score: tripComments[index].scorePrestige),
                                    ],
                                  );
                                },
                              );
                              },
                            ),
                          ),
                        ],
                                          ),
                      ),
                     tripDetail.isOwner != 0 ? SizedBox(height: 0,width: 0,) :
                     IgnorePointer(
                       child: Container(
                        height: 70,
                        decoration: const BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(18.0))),
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.white10,
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: TextField(
                                    controller: _commentController,
                                    style: GoogleFonts.roboto(
                                        color: Colors.white),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.only(left: 10.0),
                                        hintText: 'Thêm bình luận',
                                        hintStyle: GoogleFonts.roboto(
                                            color: Colors.white)),
                                  ),
                                ),
                              ),
                              tripDetail.tripStatus == 'completed'
                                  ? Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: Colors.white10,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10.0)),
                                          child: TextField(
                                            keyboardType: TextInputType.number,
                                            controller: _rateController,
                                            style: GoogleFonts.roboto(
                                                color: Colors.white),
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 10.0),
                                                hintText: 'Số điểm',
                                                hintStyle: GoogleFonts.roboto(
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(height: 0, width: 0),
                             
                              IconButton(
                                  onPressed: () {
                                    if(double.parse(_rateController.text) < 0 && double.parse(_rateController.text) > 50) {
                                       Fluttertoast.showToast(
                                            msg: "Vui lòng nhập số điểm lớn hơn 0 và bé hơn 10",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                    } else {
                                    tripBloc.add(OnCommentAndRateTrip(tripDetail.tripUid, _commentController.text, _rateController.text));
                                    }
                                  },
                                  icon: const Icon(Icons.send_rounded,
                                      color: Colors.white, size: 28))
                            ],
                          ),
                        ),
                                           ),
                     ),
                    ]
                  );
        
           },),
           ),
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
          color: isBoldValue ?  ColorTheme.textReadColor : Colors.black,
          fontWeight: !isBoldValue ? FontWeight.normal : FontWeight.w700
        ),
      ],
    );
  }

}

