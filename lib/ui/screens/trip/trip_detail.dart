import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/colors.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/domain/blocs/trip/trip_bloc.dart';
import 'package:social_media/domain/models/response/response_trip.dart';
import 'package:social_media/domain/services/trip_services.dart';
import 'package:social_media/ui/helpers/error_message.dart';
import 'package:social_media/ui/helpers/modal_loading_short.dart';
import 'package:social_media/ui/helpers/render.dart';
import 'package:social_media/ui/themes/button.dart';
import 'package:social_media/ui/themes/button_circle.dart';
import 'package:social_media/ui/themes/button_detail.dart';
import 'package:social_media/ui/themes/image_container.dart';
import 'package:social_media/ui/themes/title_appbar.dart';
import 'package:social_media/ui/widgets/circle_indicator.dart';
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
    final tripBloc = BlocProvider.of<TripBloc>(context);
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
          title: const TitleAppbar(title: "Chi tiết"),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SizedBox(
                        height: 250,
                        width: double.infinity,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: tripImages.length,
                          itemBuilder: (context, index) {
                            return ImageContainer(size: size, imgUrl: tripImages[index].tripImgUrl);
                          },),
                      ),
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
                          BtnCircle(
                            child: tripDetail.isSaved == 0 ? const Icon(Icons.bookmark_add_outlined, color: Colors.white)
                            : const Icon(Icons.bookmark_remove_outlined, color: Colors.white),
                            gradient: tripDetail.isSaved == 0 ? const LinearGradient(
                                              colors: [
                                                Color(0xFF73A0F4),
                                                Color(0xFF4A47F5),
                                              ],
                                            ) : LinearGradient(
                                            colors: [
                                              ColorTheme.bluegray400,
                                              ColorTheme.bluegray700,
                                            ],
                                          ),
                            onTap: () {
                            if(tripDetail.isSaved == 0) {
                              tripBloc.add(OnSaveTripByUser(tripDetail.tripUid, 'save'));
                            } else {
                               tripBloc.add(OnSaveTripByUser(
                                          tripDetail.tripUid, 'unsave'));
                            }
                            
                          },),
                        ],
                      ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: SizedBox(
                      width: size.width * 0.9,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Render.renderInforDetailTrip("Địa điểm:", tripDetail.tripTo),
                          const SizedBox(height: 10,),
                          Render.renderInforDetailTrip("Thời gian:", "${DateFormat('dd/MM/yyyy').format(tripDetail.dateStart)} - ${DateFormat('dd/MM/yyyy').format(tripDetail.dateEnd)}"),
                          const SizedBox(height: 10,),
                         Render.renderInforDetailTrip("Số thành viên:",
                                    " ${tripDetail.totalMemberJoined} /${tripDetail.tripMember}"),
                        ],
                      ),
                    ),
                ),

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
    ),
    );

  }

}






