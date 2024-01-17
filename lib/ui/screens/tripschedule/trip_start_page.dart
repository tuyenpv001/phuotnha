import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:social_media/colors.dart';
import 'package:social_media/data/env/env.dart';
import 'package:social_media/domain/blocs/blocs.dart';
import 'package:social_media/domain/models/response/response_trip.dart';
import 'package:social_media/domain/services/trip_services.dart';
import 'package:social_media/domain/services/user_services.dart';
import 'package:social_media/ui/screens/tripschedule/commons/haversine.dart';
import 'package:social_media/ui/screens/tripschedule/commons/load_icon.dart';
import 'package:social_media/ui/screens/tripschedule/commons/utils.dart';
import 'package:social_media/ui/themes/button.dart';
import 'package:social_media/ui/themes/colors_theme.dart';
import 'package:social_media/ui/themes/title_appbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toastification/toastification.dart';

class TripStartPage extends StatefulWidget {
  const TripStartPage({super.key, required this.tripId});
  final String tripId;
  
  @override
  State<TripStartPage> createState() => _TripStartPageState();
}

class _TripStartPageState extends State<TripStartPage> {
  late TripScheduleBloc tripScheduleBloc;
  late ResponseLocationMember tripStartInfo;
  List<MockData> mockData = [];
   CameraPosition _kgoogleMapInit =  const CameraPosition(
    target: LatLng(21.03932,105.83992),
    zoom: 13.5
  );
  final Completer<GoogleMapController> _googleMapController =
      Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;
  List<int> userFar = [];
  late List<LatLng> o;
  Set<Marker> _markers = {};
  Set<Marker> _markerInit = {};
  List<LatLng> users = [];
  List<ToastMessage> toasts = [];

  @override
  void initState() {

    tripScheduleBloc = BlocProvider.of<TripScheduleBloc>(context);
    tripScheduleBloc.initSocketChat();
    getCurrentLocation();
    super.initState();
    o = PolylinePoints().decodePolyline(Utils.path).map((e) => LatLng(e.latitude,e.longitude)).toList();

  var strJson = jsonEncode({
    "path" :  o
  });
   print(o);
   print(o.length);
   print(strJson);
  //  tripService.addStartTrip(widget.tripId, strJson);

  if(o.isNotEmpty && o.length > 5) {
    _kgoogleMapInit = CameraPosition(target: LatLng(o[0].latitude, o[0].longitude),zoom: 13.5);
    for (var i = 0; i < 5; i++) {
      users.add(o[i]);
    }
  }
  _getMarkerbyTrip();
  _setMarkerMember();
  
  }

  _getMarkerbyTrip() async {
    var markerList = await tripService.getMarkersByUidTrip(widget.tripId);
     late Uint8List resizedImage;
          for (var item in markerList) {
      if (item.isGasStation == 1) {
        resizedImage = await getIconByType('gas-station.png');
      } else if (item.isRepairMotobike == 1) {
        resizedImage = await getIconByType('car-repair.png');
      } else if (item.isEatPlace == 1) {
        resizedImage = await getIconByType('eat.png');
      } else if (item.isCheckIn == 1) {
        resizedImage = await getIconByType('check-in.png');
      } else {
        resizedImage = await getIconByType('location.png');
      }
      _markerInit.add(Marker(
          markerId: MarkerId(item.uid),
          icon: BitmapDescriptor.fromBytes(resizedImage),
          position: LatLng(item.lat, item.lng),
          infoWindow: InfoWindow(
              title: item.isGasStation == 1
                  ? 'Trạm xăng'
                  : item.isRepairMotobike == 1
                      ? 'Sửa xe'
                      : '',
              snippet: item.addressShort)));
    }
    setState(() {});
  }


  Future<void> _setMarkerMember() async {
    for (var user in mockData) {
       Uint8List icon =  await getIconByType(user.image);
      _markers.add(Marker(
          markerId: MarkerId(user.image),
          infoWindow: InfoWindow(
            title: user.fullname,
            snippet: user.message
          ),
          visible: true,
          icon: BitmapDescriptor.fromBytes(icon),
          position: LatLng(user.lat, user.lng)));
    }
  }
  

  @override
  void dispose() {
  
    tripScheduleBloc.disconnectSocket();
    tripScheduleBloc.disconnectSocketMessagePersonal();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return 
    BlocListener<TripScheduleBloc, TripScheduleState>(
      listener: (context, state) {
        if( state is LoadingSaveTripSchedule || state is LoadingSaveTripSchedule){}
          // modalLoadingShort(context);
        
        if ( state is SuccessTripSchedule ){
          Navigator.pop(context);
          setState((){});
          }
      },
      child: 
  
    Scaffold(
        appBar: _appBar(),
        body:   FutureBuilder(
          future: tripService.getLocationAllMemberOfTrip(widget.tripId),
          builder:(context, snapshot) {
             if (snapshot.hasData) {
              // print(snapshot.data.members);
              tripStartInfo = snapshot.data!;
              mockData = snapshot.data!.mockData;
              toasts = snapshot.data!.toats;
              // _setMarkerMember();
            }
            return Stack(
            alignment: Alignment.topRight,
            children:[
              GoogleMap(
                myLocationEnabled: true,
                mapType: MapType.normal,
                initialCameraPosition: _kgoogleMapInit,
                onMapCreated: (controller) {
                  controllerGoogleMap = controller;
                  _googleMapController.complete(
                    controllerGoogleMap
                  );
                },
                polylines: {
                  Polyline(
                    polylineId:const PolylineId("RouteTesst"),
                    points: o,
                    width: 5,
                    color: Colors.black87
                  ),
                },
                markers: _markers.union(_markerInit),
        
                ),
        
              IgnorePointer(
                ignoring: true,
                child: Container(
                  height: size.height * 0.4,
                  padding: const EdgeInsets.only(right: 10, top: 5),
                  constraints: BoxConstraints(
                    minWidth: size.width * 0.2
                  ),
                  // color: Colors.amberAccent,
                  child: mockData.isEmpty ? const SizedBox(height: 0,width: 0,) : ListView.builder(
                    itemCount: mockData.length,
                    itemBuilder: (context, index) {
                      print(mockData);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: _renderInforMember(mockData[index]),
                      );
                  },),
                ),
              )
            ]
          );
          }
        ),
       floatingActionButton:  InkWell(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: ColorsCustom.primary,
            borderRadius:BorderRadius.circular(50) 
          ),
          child: const Icon(Icons.play_arrow, color: Colors.white,)),
        onTap: ()  async {
          // Xóa tất cả các marker cũ
          _markers.clear();
          for (int i = 0; i < o.length; i++) {
                 _setMarkerRun();
                _showToast(toasts);
                // _setMarkerMember();
 
             tripScheduleBloc
                  .add(OnUpdateLocationAllMemberTrip(tripId: widget.tripId));
              setState(() {
              });
               await Future.delayed(const Duration(seconds: 2));
          }
        },
       ),
    ),
    );
  }

  Widget _renderInforMember(MockData member) {

    print(member.index);
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                   color: _getColorFromType(member.type)
                ),
              ),
                Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: ColorTheme.bgGreyBold,
                      blurRadius: 10,
                      offset: const Offset(5, 0)
                    )
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(image: NetworkImage("${Environment.baseUrl}${member.image}"),
                  fit: BoxFit.fill
                  ),
                ),
                ),
              ]
            ),
            Container(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: _getColorFromType(member.type)
            ),
            child: Text(member.fullname, style: const TextStyle(color: Colors.white)),
          ),
          ],
        ),
        _isShow(member.type) ? Padding(
          padding: const EdgeInsets.only(right: 80),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: _getColorFromType(member.type)
            ),
            child: Text(member.message),
          ),
        ) : const SizedBox(height: 0,width: 0),

      ],
    );
  }

Future<void> _setMarkerRun() async {

  // test.mockData
  for (int i = 0; i < mockData.length; i++) {
    Uint8List icon = await getIconByType(mockData[i].image);
    _markers.add(
      Marker(        
        markerId: MarkerId("user$i"),
        position: users[i],
        icon: userFar.contains(i) ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed) : BitmapDescriptor.fromBytes(icon),
        // Các thuộc tính khác của marker
      ),
    );
  }

}


  Future<void> getCurrentLocation() async {
    await Permission.locationWhenInUse.isDenied.then((value)  {
      Permission.locationWhenInUse.request();
    });
     await Permission.notification.isDenied.then((valueOfPermission) {
      if (valueOfPermission) {
        Permission.notification.request();
      }
    });
  }
 
  AppBar  _appBar () {
    return AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: const TitleAppbar(title: "Đang đi"),
          elevation: 0,
          actions: [
            Button(bg: ColorTheme.bgGrey,height: 40,width: 40,icon:const Icon(Icons.close, color: Colors.black),onPress: () {
              Navigator.pop(context);
           
        },),
      ],
    );
  }

  Color _getColorFromType(String type) {
    if (type == "danger") return ColorTheme.bgDanger;
    if (type == "warning") return ColorTheme.bgWarning;
    if (type == "off") return ColorTheme.bluegray700;
    return ColorTheme.bgPrimary;
  }

  bool _isShow(String type) {
    if (type == "danger") return true;
    if (type == "warning") return true;
    return false;
  }

  void _showToast(List<ToastMessage> toasts) {
      for (var toast in toasts) {
        toastification.show(
        context: context,
        type: ToastificationType.success,
        style: ToastificationStyle.flat,
        autoCloseDuration: const Duration(seconds: 5),
        title: toast.from,
        description: toast.from + ' gần đến ' + toast.to + '. Khoảng ${toast.distance.toStringAsFixed(2)} km',
        alignment: Alignment.topRight,
        direction: TextDirection.ltr,
        animationDuration: const Duration(milliseconds: 300),
        icon: const Icon(Icons.check),
        primaryColor: Colors.deepOrange,
        backgroundColor: toast.type['type'] ==  'isEatPlace' ? Colors.yellow : toast.type['type'] == 'isGasStation' ? Colors.blueAccent : Colors.white ,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x07000000),
            blurRadius: 16,
            offset: Offset(0, 16),
            spreadRadius: 0,
          )
        ],
        showProgressBar: true,
        closeButtonShowType: CloseButtonShowType.onHover,
        closeOnClick: false,
        pauseOnHover: true,
        dragToClose: true,
        callbacks: ToastificationCallbacks(
          onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
          onCloseButtonTap: (toastItem) =>
              print('Toast ${toastItem.id} close button tapped'),
          onAutoCompleteCompleted: (toastItem) =>
              print('Toast ${toastItem.id} auto complete completed'),
          onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
        ),
      );
      }
        
      

  }



} 



 