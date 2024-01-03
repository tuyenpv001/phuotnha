
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media/colors.dart';
import 'package:social_media/data/env/env.dart';
import 'package:social_media/domain/blocs/trip/trip_bloc.dart';
import 'package:social_media/domain/models/response/response_trip_by_user.dart';
import 'package:social_media/domain/services/trip_services.dart';
import 'package:social_media/ui/helpers/error_message.dart';
import 'package:social_media/ui/helpers/modal_loading_short.dart';
import 'package:social_media/ui/screens/profile/profile_page.dart';
import 'package:social_media/ui/themes/button.dart';
import 'package:social_media/ui/themes/colors_theme.dart';
import 'package:social_media/ui/themes/title_appbar.dart';
import 'package:social_media/ui/widgets/widgets.dart';
import 'package:intl/intl.dart';

class TripsCreatedPage extends StatefulWidget {
  const TripsCreatedPage({super.key});

  @override
  State<TripsCreatedPage> createState() => _TripsCreatedPageState();
}

class _TripsCreatedPageState extends State<TripsCreatedPage> {
  @override
  Widget build(BuildContext context) {
    return
       BlocListener<TripBloc, TripState>(
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const TitleAppbar(title: "Chuyến đi đã tạo"),
        leading: Button(
          height: 40, 
          width: 40, 
          bg: ColorTheme.bgGrey, 
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black), 
          onPress:() {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                builder: (context) {
                  return const ProfilePage();
                },
              ), (_) => true);
          },),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: FutureBuilder(
          future: tripService.listTripByUser(),
          builder: (context, snapshot) {
            return !snapshot.hasData ?
                const Center(child: Text('Loading...'),)
                : ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListItem(trip: snapshot.data![index]);
                },);
          },),
      ),
    ),
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem({super.key, required this.trip});
  final TripUser trip;

  @override
  Widget build(BuildContext context) {
    final tripBloc = BlocProvider.of<TripBloc>(context);
    var size = MediaQuery.of(context).size;
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
        alignment: Alignment.topRight,
        children:[
          Column(
          children: [
             Container(
              height: 185,
              width: double.maxFinite,
              alignment: Alignment.topRight,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: NetworkImage(Environment.baseUrl + trip.image),
                      fit: BoxFit.cover)),
            ),
                      const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: size.width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(trip.title,style:const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600
                  )),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      const TextCustom(
                          text: "Thời gian: ",
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                      TextCustom(
                        text:
                            "${DateFormat('dd/MM/yyyy').format(trip.dateStart)} - ${DateFormat('dd/MM/yyyy').format(trip.dateEnd)}",
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
                        text: " ${trip.totalMemberJoined} /${trip.tripMember}",
                        fontSize: 15,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        
        Column(
          children:[
            Button(
              onPress: () {
                tripBloc.add(OnDeleteTrip(trip.uid));
              },
              height: 50, 
              width: 50, 
              bg: ColorTheme.bgDanger.withOpacity(0.8), 
              icon:const  Icon(Icons.delete_outline_outlined, color: Colors.white,),
            ),
            Button(
              onPress: () {
                
              },
              height: 50, 
              width: 50, 
              bg: ColorsCustom.primary.withOpacity(0.8), 
              icon:const  Icon(Icons.mode_edit_outline_outlined, color: Colors.white,),
            ),
          ]
        )
        ]
      ),
    );
  }
}