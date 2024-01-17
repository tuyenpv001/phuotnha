import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/domain/blocs/blocs.dart';
import 'package:social_media/domain/models/response/response_trip.dart';
import 'package:social_media/domain/services/trip_services.dart';
import 'package:social_media/ui/helpers/animation_route.dart';
import 'package:social_media/ui/helpers/error_message.dart';
import 'package:social_media/ui/helpers/modal_loading_short.dart';
import 'package:social_media/ui/screens/trip/add_trip.dart';
import 'package:social_media/ui/screens/trip/items/trip_item.dart';
import 'package:social_media/ui/screens/trip/trip_detail.dart';
import 'package:social_media/ui/themes/colors_theme.dart';
import 'package:social_media/ui/themes/title_appbar.dart';
import 'package:social_media/ui/widgets/heading_block.dart';
import 'package:social_media/ui/widgets/widgets.dart';

class TripPage extends StatefulWidget {
  const TripPage({super.key});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  final someText = "Đà Lạt là thành phố tỉnh lỵ trực thuộc tỉnh Lâm Đồng, nằm trên cao nguyên Lâm Viên, thuộc vùng Tây Nguyên, Việt Nam. Từ xa xưa, vùng đất này vốn là địa bàn cư trú của những cư dân người Lạch, người Chil và người Srê thuộc dân tộc Cơ Ho";
  @override
  Widget build(BuildContext context) {
    

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
    child:
    Scaffold(
      backgroundColor: Colors.white,
    
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const TitleAppbar(title: "Chuyến đi",),
        elevation: 0,
        actions: [
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: ColorsCustom.primary,
                  borderRadius: BorderRadius.circular(50)),
              child: IconButton(
                  splashRadius: 20,
                  onPressed: () => Navigator.pushAndRemoveUntil(context,
                    routeSlide(page: const AddTripPage()), (_) => false),
                  icon: const Icon(Icons.add)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          children: [
              const HeadingBlock(title: "Hãy cùng nhau", subTile: "tạo nên những kỷ niệm đẹp"),
              const SizedBox(height: 10,),
              FutureBuilder(
              future: tripService.getAllTripHome(),
               builder: ((context, snapshot) {
                 if( snapshot.data != null && snapshot.data!.isEmpty){
                    return const Text("Không có chuyến đi nào được tạo.");
                  }
                  return !snapshot.hasData
                  ? const Text("loading....")
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, i) => _ListViewTrip(trip: snapshot.data![i]),
                    );
               }))
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(index: 2),  
    ),
    );
  }
}

class _ListViewTrip  extends StatelessWidget{
   final Trip trip;

  const _ListViewTrip({Key? key, required this.trip}) : super(key: key);
  @override
  Widget build(BuildContext context) {

      return GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return TripDetailPage(tripId: trip.tripUid);
          },));
        },
        
        child: TripItem(title: trip.title, totalMemberJoined: trip.totalMemberJoined, description: trip.description, tripUid: trip.tripUid, createdAt: trip.createdAt, dateStart: trip.dateStart, 
        dateEnd: trip.dateEnd,username: trip.username, avatar: trip.avatar, images: trip.images, tripMember: trip.tripMember, isClose: trip.isClose, isJoined: trip.isJoined, isLeader: trip.isLeader, tripFrom: trip.tripFrom, tripTo: trip.tripTo, isOwner: trip.isOwner,score: trip.score,)
        );
  }
}

