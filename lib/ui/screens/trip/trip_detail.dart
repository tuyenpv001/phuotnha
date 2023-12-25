import 'package:flutter/material.dart';
import 'package:social_media/colors.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/data/env/env.dart';
import 'package:social_media/domain/models/response/response_trip.dart';
import 'package:social_media/domain/services/trip_services.dart';
import 'package:social_media/ui/themes/button.dart';
import 'package:social_media/ui/themes/colors_theme.dart';
import 'package:social_media/ui/widgets/widgets.dart';
import 'package:intl/intl.dart';

class TripDetailPage extends StatefulWidget {
  const TripDetailPage({super.key, required this.tripId});
  final String tripId;
  @override
  State<TripDetailPage> createState() => _TripDetailPageState();
}

class _TripDetailPageState extends State<TripDetailPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TripDetail tripDetail;
  late List<TripImage> tripImages;
  late List<TripMember> tripMembers;
  late List<TripRecommend> tripRecommends;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
        body: 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: FutureBuilder(
              future: tripService.getDetailTripById(widget.tripId),
             builder: (context, snapshot) {
                if(snapshot.hasData) {
                  if(snapshot.data!.trip.isNotEmpty) {
                    tripDetail = snapshot.data!.trip[0];
                  }
                  if(snapshot.data!.tripMembers.isNotEmpty) {
                    tripMembers = snapshot.data!.tripMembers;
                  }
                  if(snapshot.data!.tripRecommends.isNotEmpty) {
                    tripRecommends = snapshot.data!.tripRecommends;
                  }
                  if(snapshot.data!.images.isNotEmpty) {
                    tripImages = snapshot.data!.images;
                  }
                }
                
               return  !snapshot.hasData
                  ? const Center(child: Text("Loading...")) :
                 ListView(
              children: [
                Container(
                  height: 250,
                  width: size.width * 0.9,
                  margin:const  EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white60, width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                          image: NetworkImage(Environment.baseUrl + tripDetail.avatar),
                          fit: BoxFit.cover)),
                ),
                SizedBox(
                  height: 80,
                  width: double.infinity,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    padding:const  EdgeInsets.symmetric(horizontal: 15),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                 
                        },
                        child: Container(
                          height: 60,
                          width: size.width * 0.9 / 4,
                          margin:const  EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white60, width: 1),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              image:const  DecorationImage(
                                  image:
                                      AssetImage("assets/asset/images/profile.jpg"),
                                  fit: BoxFit.cover)),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(tripDetail.title, style: kTitle2Style),
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
                              text: tripDetail.tripTo,
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
                              text:
                                  "${DateFormat.yMd().format(tripDetail.dateStart)} - ${DateFormat.yMd().format(tripDetail.dateEnd)}",
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
                              text: " ${tripDetail.totalMemberJoined} /${tripDetail.tripMember}",
                              fontSize: 15,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF73A0F4),
                              Color(0xFF4A47F5),
                            ],
                          ),
                        ),
                        child:const Icon(Icons.bookmark, color: Colors.white),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF73A0F4),
                            Color(0xFF4A47F5),
                          ],
                        ),
                      ),
                      child: TextButton(
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        child: const TextCustom(
                            text: "Tham gia", color: Colors.white, fontSize: 16),
                        onPressed: () {
                       
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ), // List tabs
                SizedBox(
                  height: 60,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        labelPadding: const EdgeInsets.only(left: 20, right: 20),
                        labelColor: Colors.blueAccent,
                        unselectedLabelColor: Colors.grey,
                        indicator:
                            CircleTabIndicator(color: Colors.blueAccent, radius: 4),
                        tabs: [
                          Tab(
                              child: Text(
                            "Thông tin chi tiết",
                            style: kHeadlineLabelStyle,
                          )),
                          Tab(
                              child: Text(
                            "Lịch trình cụ thể",
                            style: kHeadlineLabelStyle,
                          )),
                          Tab(
                              child: Text(
                            "Địa điểm gợi ý",
                            style: kHeadlineLabelStyle,
                          )),
                        ]),
                  ),
                ),
                //Content tab
                SizedBox(
                height: 500,
                child: TabBarView(controller: _tabController, children: [
                  ListView(
                    children: [
                      Text(tripDetail.description),
                    ],
                  ),
                  ListView(
                    children:[
                      Text(
                         tripDetail.description),
                    ],
                  ),
                  ListView(
                    children:  [
                      Text(
                          tripDetail.description),
                    ],
                  ),
                ]),
              )
              ],
            );
                }),
          ),
    );
  }
}

// ignore: must_be_immutable
class CircleTabIndicator extends Decoration {
  final Color color;
  double radius;

  CircleTabIndicator({required this.color, required this.radius});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CirclePainter(color: color, radius: radius);
  }
}

class _CirclePainter extends BoxPainter {
  final double radius;
  late Color color;
  _CirclePainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    late Paint _paint;
    _paint = Paint()..color = color;
    _paint = _paint..isAntiAlias = true;
    final Offset circleOffset =
        offset + Offset(cfg.size!.width / 2, cfg.size!.height - radius);

    canvas.drawCircle(circleOffset, radius, _paint);
  }
}
