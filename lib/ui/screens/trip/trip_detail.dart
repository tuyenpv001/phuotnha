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
    _tabController = TabController(vsync: this, length: 2);
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
                SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: tripImages.length,
                    itemBuilder: (context, index) {
                      return ImageContainer(size: size, imgUrl: tripImages[index].tripImgUrl);
                    },),
                ),
   
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(tripDetail.title,
                                 style: const TextStyle(
                                    fontSize: 20.0,
                                    
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryLabelColor,
                                    fontFamily: 'SF Pro Text',
                                    overflow: TextOverflow.ellipsis
                                  ),
                                  maxLines: 3,
                                  ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        BtnTripDetail(
                          child: const Text("Tham gia",
                              style: TextStyle(color: Colors.white)),
                          onTap: () {
                            print("Đã tham gia");
                          },
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF73A0F4),
                                  Color(0xFF4A47F5),
                                ],
                              ),
                            ),
                            child: const Icon(
                                Icons.bookmark_add_outlined,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                SizedBox(
                    width: size.width * 0.9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _renderInfo("Địa điểm:", tripDetail.tripTo),
                        const SizedBox(height: 5,),
                        _renderInfo("Thời gian:", "${DateFormat.yMd().format(tripDetail.dateStart)} - ${DateFormat.yMd().format(tripDetail.dateEnd)}"),
                        const SizedBox(height: 5,),
                        _renderInfo("Số thành viên:",
                                  " ${tripDetail.totalMemberJoined} /${tripDetail.tripMember}"),
                      ],
                    ),
                  ),
                const SizedBox(height: 10,),

                 // List tabs
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
                            "Địa điểm đánh dấu",
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

  Row _renderInfo(String title, String detail) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextCustom(
            text: title,
            fontSize: 15,
            color: Colors.black87,
            fontWeight: FontWeight.normal),
        TextCustom(
          text: detail,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}

class BtnTripDetail extends StatelessWidget {
  const BtnTripDetail({
    super.key, required this.child, this.onTap,
  });

  final void Function()? onTap;
  final Widget? child;
  

  @override
  Widget build(BuildContext context) {
    return InkWell(
           onTap: onTap,
           child: Container(
             padding: const EdgeInsets.symmetric(
                 horizontal: 15, vertical: 10),
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
          fit:BoxFit.fill,  
          image: NetworkImage(Environment.baseUrl + imgUrl))
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
