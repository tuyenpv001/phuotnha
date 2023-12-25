import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_media/colors.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/data/env/env.dart';
import 'package:social_media/domain/models/response/response_trip.dart';
import 'package:social_media/domain/services/trip_services.dart';
import 'package:social_media/ui/screens/tripschedule/trip_detail_schedule.dart';
import 'package:social_media/ui/screens/tripschedule/trip_messages_page.dart';
import 'package:social_media/ui/screens/tripschedule/trip_start_page.dart';
import 'package:social_media/ui/themes/title_appbar.dart';
import 'package:intl/intl.dart';
import 'package:social_media/ui/widgets/widgets.dart';

class TripSchedulePage extends StatefulWidget {
  const TripSchedulePage({super.key});

  @override
  State<TripSchedulePage> createState() => _TripScheduleState();
}

class _TripScheduleState extends State<TripSchedulePage> {
  late String dayOfWeek;
  late int dateOfMonth;
  late DateTime lastDateOfMonth;
  DateTime dateCurr =  DateTime.now();
  
  @override
  void initState() {
    super.initState();
    dayOfWeek = 'T2';
    lastDateOfMonth = DateTime.utc(DateTime.now().year, DateTime.now().month + 1).subtract(const Duration(days: 1));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavigation(index: 3),
      appBar: AppBar(
           backgroundColor: Colors.white,
      title: const TitleAppbar(title: "Danh sách chuyến đi"),
      elevation: 0,

      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
             mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const CalendarScheduleTrip(),
              
              FutureBuilder(
                future: tripService.getAllTripSchedule(),
                 builder: (context, snapshot) {
                  if (snapshot.data != null && snapshot.data!.isEmpty) {
                    return const Text("Không có chuyến đi nào được tạo.");
                  }
                   return !snapshot.hasData ? const Text("Không có dữ liệu") :ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, i) =>
                        ScheduleTripItem(tripSchedule: snapshot.data![i]),
                  );
                  
                 },)
            ],
          ),
        ),
      ),
    );
  }
}

class ScheduleTripItem extends StatelessWidget {
  final TripSchedule tripSchedule;
  const ScheduleTripItem({
    super.key,
    required this.tripSchedule,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 15,right: 20),
      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),

      decoration:const  BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(241, 243, 245, 1),
                offset: Offset(0, 5),
                blurRadius: 2)
          ]
      ),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: Environment.baseUrl + tripSchedule.thumbnail,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(tripSchedule.title,
                          style: kHeadlineLabelStyle.copyWith(
                            overflow: TextOverflow.ellipsis
                          )),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_pin,
                            color: Color.fromRGBO(
                                12, 110, 252, 1),
                              size: 20),
                      const SizedBox(
                        width: 5,
                      ),
                        Text(tripSchedule.tripTo),
                        ]
                    ),
                    Row(
                      children: [
                        const Icon(Icons.person_2,
                            color: Color.fromRGBO(
                                12, 110, 252, 1),
                              size: 20),
                        const SizedBox(width: 5,),
                        Text("${tripSchedule.totalMemberJoined}/ ${tripSchedule.tripMember}"),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            color: Color.fromRGBO(
                                12, 110, 252, 1),
                                size: 20),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(DateFormat("dd/MM/yyy").format(tripSchedule.dateStart)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            color: Color.fromRGBO(
                                12, 110, 252, 1),
                                size: 20),
                        const SizedBox(width: 5,),
                        Text(DateFormat("dd/MM/yyy").format(tripSchedule.dateEnd), 
                        style:const  TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
                    
          Padding(
            padding: const EdgeInsets.only(top: 14,bottom: 10),
            child: Row(
              mainAxisAlignment:tripSchedule.isOwner == 0 ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
              children: [
               
                 ButtonSchedule(tripSchedule: tripSchedule,title: "Trò chuyện", onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return ChatMessagesTripPage(
                          tripUid: tripSchedule.tripUid,
                           title: tripSchedule.title
                        );
                      },
                    ));
                 },),
                 const SizedBox(width: 5,),
                 ButtonSchedule(tripSchedule: tripSchedule,title: "Chi tiết", onPressed: () {
                  print("OKKK");
                   Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return TripDetailSchedulePage(
                          tripId: tripSchedule.tripUid,
                        );
                      },
                    ));
                 },),
                 const SizedBox(
                  width: 5,
                ),
                tripSchedule.isOwner != 0 ?
                 ButtonSchedule(tripSchedule: tripSchedule,title: "Bắt đầu", onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return TripStartPage(
                          tripId: tripSchedule.tripUid,
                        );
                      },
                    ));
                 },) : const SizedBox(),
                
              ],
            ),
          ),
         
        ],
      ),
    );
  }
}

class ButtonSchedule extends StatelessWidget {
   const ButtonSchedule({
    super.key,
    required this.tripSchedule, required this.title,
    required this.onPressed
  });

  final TripSchedule tripSchedule;
  final String title;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
     height: 35,
     constraints: const BoxConstraints(maxWidth: 150, minWidth: 100),
     padding: const EdgeInsets.symmetric(horizontal: 5),
     decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(10.0),
         border:
             Border.all(color: const Color(0xFF73A0F4), width: 1)),
     child: TextButton(
       style: TextButton.styleFrom(
           shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(10))),
       child: TextCustom(
           text: title, color: Colors.black87, fontSize: 16),
       onPressed: () {
         onPressed();
       },
     ),
    );
  }
}

class CalendarScheduleTrip extends StatefulWidget {
  const CalendarScheduleTrip({
    super.key,
  });

  @override
  State<CalendarScheduleTrip> createState() => _CalendarScheduleTripState();
}

class _CalendarScheduleTripState extends State<CalendarScheduleTrip> {
  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 20,top: 24,right: 20),
      decoration:const  BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(241, 243, 245, 1),
            offset: Offset(0, 5),
            blurRadius: 2
          )
        ]
      ),
      child:  Column(
          mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 15,top: 18,right: 16),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 2, top: 1),
                    child: Text("Ngày 21 Tháng 12",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16,left: 16,right: 16,top: 14),
             child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                DayOfWeekItem(date: '18',label: "T2",isActive: false),
                DayOfWeekItem(date: '19',label: "T3",isActive: false),
                DayOfWeekItem(date: '20',label: "T4", isActive: false),
                DayOfWeekItem(date: '21',label: "T5", isActive: true),
                DayOfWeekItem(date: '22',label: "T6", isActive: false),
                DayOfWeekItem(date: '23',label: "T7", isActive: false),
                DayOfWeekItem(date: '24',label: "CN", isActive: false),
              ],
            ),
          ),

          // Container(
          //   height: 100,
          //   width: double.infinity,
          //   child: PageView.builder(
          //     itemCount: 15,
          //     scrollDirection: Axis.horizontal,
          //     controller: PageController(initialPage: 5,viewportFraction: 0.2),
          //     itemBuilder: (context, index) {
          //       bool check = index == activeIndex ? true: false;
          //     return InkWell(
          //       onTap: () {
          //         setState(() {
          //           activeIndex = index;
          //         });
          //       },
          //       child: Padding(
          //         padding:const  EdgeInsets.only(bottom: 16, left: 10, right: 10, top: 14),
          //         child: DayOfWeekItem(date: "$index",label: "T2",isActive: check),
          //       ),
          //     );
          //   },),
          // )
        ],
      ),
    );
  }
}

class DayOfWeekItem extends StatelessWidget {
  const DayOfWeekItem({
    super.key, required this.label, required this.date, required this.isActive,
  });
  final String label;
  final String date;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? blue400 :  Colors.white ,
        borderRadius: BorderRadius.circular(12)
      ),
      child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(top: 12,left: 12,right: 12 ),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                     Align(
                        alignment: Alignment.center,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 2,right: 1),
                            child: Text(label,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: isActive ? bluegray400 : bluegray700,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                      ),
                      Padding(
                        padding:const EdgeInsets.only(top: 12,bottom: 12),
                        child: Text(date,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                               color: isActive ? Colors.white : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ),
                  ],),
                  ),
        ],
      ),
    );
  }
}

