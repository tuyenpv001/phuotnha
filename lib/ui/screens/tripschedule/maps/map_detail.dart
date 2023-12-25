import 'dart:async';

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
        height: size.height * 0.8,
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


  Future<void> _getPolyline() async {
   
      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult polylineResult =
          await polylinePoints.getRouteBetweenCoordinates(
              Environment.apiKey,
              PointLatLng(widget.tripRecommends[0].lat, widget.tripRecommends[0].lng),
              PointLatLng(widget.tripRecommends[widget.tripRecommends.length - 1].lat,
                  widget.tripRecommends[widget.tripRecommends.length - 1].lng));

      if (polylineResult.points.isNotEmpty) {
        for (var point in polylineResult.points) {
          polyLineCoordiates.add(LatLng(point.latitude, point.longitude));
        }
      }
  }
  
    void _getAllMarker() {
        
      for (var item in widget.tripRecommends) {
        _marker.add(Marker(
          markerId: MarkerId(item.uid),
          icon: item.isGasStation == 1 ? getIcon('gas') : item.isRepairMotobike == 1 ? getIcon("repair") : BitmapDescriptor.defaultMarker,
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

    BitmapDescriptor getIcon(String type) {
      if(type == 'gas') {
         BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(48, 48)), 'assets/asset/icons/gas_station.png').then((value){
          return value;
        });
      }
      if(type == 'repair') {
         BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, 'assets/asset/icons/repair_motobike.png').then((value) => value);
      }
      return BitmapDescriptor.defaultMarker;
    }



}