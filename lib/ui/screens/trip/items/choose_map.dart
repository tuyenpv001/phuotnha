import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:social_media/ui/screens/tripschedule/commons/utils.dart';

class ChooseMapLocation extends StatefulWidget {
  const ChooseMapLocation({super.key});

  @override
  State<ChooseMapLocation> createState() => _ChooseMapLocationState();
}

class _ChooseMapLocationState extends State<ChooseMapLocation> {
  
  final CameraPosition _kgoogleMapInit =
      const CameraPosition(target: LatLng(10.772129, 106.724629), zoom: 15);
  final Completer<GoogleMapController> _googleMapController =
      Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;
  Position? currentPosition;

  double bottomMapPadding = 276;


  Future<void> getCurrentLivePosition() async {
    Position positionUser = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = positionUser;
    LatLng positionOfUserInLatLng = LatLng(currentPosition!.latitude, currentPosition!.longitude);
    CameraPosition cameraPosition = CameraPosition(target: positionOfUserInLatLng, zoom: 15);
    await Utils.convertGeoGraphicCoOrdinatesIntoHumanReadableAddress(currentPosition!, context);
    controllerGoogleMap!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:   Stack(
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
                getCurrentLivePosition();
               
              },
            ),
          
          ]
        ),
       
    );
  }
}