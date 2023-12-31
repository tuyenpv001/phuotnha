import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:social_media/data/env/env.dart';
import 'package:social_media/domain/models/response/response_trip.dart';
import 'package:social_media/ui/screens/tripschedule/commons/utils.dart';


class MapDetail extends StatefulWidget {
  const MapDetail({super.key, required this.tripRecommends});
  final List<TripRecommend> tripRecommends;

  @override
  State<MapDetail> createState() => _MapDetailState();
}

class _MapDetailState extends State<MapDetail> {
    late LatLng a;
    late LatLng b;
   final CameraPosition _kgoogleMapInit =
      const CameraPosition(target: LatLng(10.772129, 106.724629), zoom: 15);
  final Completer<GoogleMapController> _googleMapController =
      Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;
  late List<LatLng> polyLineCoordiates;
  Set<Marker> _marker = {};
  Set<Polyline> _polyline = {};
  late Direction _direction;
  


  @override
  void initState() {
    _getAllMarker();
    super.initState();
    a = LatLng(widget.tripRecommends[0].lat, widget.tripRecommends[0].lng);
    b = LatLng(widget.tripRecommends[widget.tripRecommends.length - 1].lat, widget.tripRecommends[widget.tripRecommends.length - 1].lng);  
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: Utils.getDirectionTwoPoint(a,b),
      builder:(context, snapshot) {
        if(snapshot.hasData) {
          polyLineCoordiates = snapshot.data!.routes[0].polylinePoints.map((e) => LatLng(e.latitude, e.longitude)).toList();
        }

        return !snapshot.hasData ? Center(child: Text("loading..."),): 
       Container(
        height: size.height ,
          decoration: BoxDecoration(
          
            borderRadius: BorderRadius.circular(14),
            // boxShadow: [
            //   BoxShadow(
            //       color: bgGrey,
            //       offset: const Offset(0, 5),
            //       blurRadius: 5.0)
            // ]
            ),
        child: Stack(
          // clipBehavior: Clip.antiAlias,
            children:[
              GoogleMap(
                myLocationEnabled: true,
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.tripRecommends[widget.tripRecommends.length - 1].lat, widget.tripRecommends[widget.tripRecommends.length - 1]
                        .lng),
                        
                  zoom: 14),
                onMapCreated: (controller) {
                  controllerGoogleMap = controller;
                  _googleMapController.complete(
                    controllerGoogleMap
                  );
                },
                markers: _marker,
                polylines: {
                  Polyline(
                  polylineId: PolylineId("Route"),
                  points: polyLineCoordiates,
                  width: 5,
                  color: Colors.black
                  ),
                },
                )
            ]
          ),
      );
      }
    );
  }



  
    Future<void> _getAllMarker() async {
     late Uint8List resizedImage;
      for (var item in widget.tripRecommends) {
        if(item.isGasStation == 1) {
          resizedImage = await getIconByType('gas-station');
        } 
        else if(item.isRepairMotobike == 1) {
          resizedImage = await getIconByType('car-repair');
        }
        else if (item.isEatPlace == 1) {
        resizedImage = await getIconByType('eat');
        }
        else if (item.isCheckIn == 1) {
        resizedImage = await getIconByType('check-in');
        } 
        else {
          resizedImage = await getIconByType('location');
        }
        _marker.add(Marker(
          markerId: MarkerId(item.uid),
          icon:  BitmapDescriptor.fromBytes(resizedImage),
          position: LatLng(item.lat, item.lng),
          infoWindow: InfoWindow(
              title: item.isGasStation == 1
                  ? 'Trạm xăng'
                  : item.isRepairMotobike == 1
                      ? 'Sửa xe'
                      : '',
          snippet: item.addressShort)));
      }
      setState(() {
        
      });
    }

    Future<Uint8List> getIconByType(String imageName) async {
      Uint8List? image = await loadNetworkImage(imageName);
      final ui.Codec markerImageCodec = await instantiateImageCodec(
        image.buffer.asUint8List(),
        targetHeight: 100,
        targetWidth: 100
      );
      
      final ui.FrameInfo frameInfo = await markerImageCodec.getNextFrame();
      final ByteData? byteData = await frameInfo.image.toByteData(
        format: ui.ImageByteFormat.png
      );
      final Uint8List resizedImage = byteData!.buffer.asUint8List();
      return resizedImage;
    }


  Future<Uint8List> loadNetworkImage(String nameImage) async {
    final complater = Completer<ImageInfo>();
    var image = NetworkImage(Environment.baseUrl + nameImage +".png");
    image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener((info, synchronousCall) =>
        complater.complete(info)
      )
    );

    final imageInfo = await complater.future;
    
    final byteData = await imageInfo.image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();

  }

  Future<void> _getPolyline() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult polylineResult =
        await polylinePoints.getRouteBetweenCoordinates(
            Environment.apiKey,
            PointLatLng(
                widget.tripRecommends[0].lat, widget.tripRecommends[0].lng),
            PointLatLng(
                widget.tripRecommends[widget.tripRecommends.length - 1].lat,
                widget.tripRecommends[widget.tripRecommends.length - 1].lng));

    if (polylineResult.points.isNotEmpty) {
      for (var point in polylineResult.points) {
        polyLineCoordiates.add(LatLng(point.latitude, point.longitude));
      }
    }
  }

}