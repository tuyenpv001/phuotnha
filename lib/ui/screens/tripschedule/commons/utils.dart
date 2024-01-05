import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:social_media/data/env/env.dart';

class Utils {

   static sendRequestToAPI(String apiUrl) async {
    http.Response responseFromAPI = await http.get(Uri.parse(apiUrl));

    try {
      if (responseFromAPI.statusCode == 200) {
        String dataFromApi = responseFromAPI.body;
        var dataDecoded = jsonDecode(dataFromApi);
        return dataDecoded;
      } else {
        return "error";
      }
    } catch (errorMsg) {
      return "error";
    }
  }

  ///Reverse GeoCoding
  static Future<String> convertGeoGraphicCoOrdinatesIntoHumanReadableAddress(
      Position position, BuildContext context) async {
    String humanReadableAddress = "";
    String apiGeoCodingUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${Environment.apiKey}";

    var responseFromAPI = await sendRequestToAPI(apiGeoCodingUrl);

    if (responseFromAPI != "error") {
      humanReadableAddress = responseFromAPI["results"][0]["formatted_address"];
      print("humanReadableAddress = " + humanReadableAddress);
    }

    return humanReadableAddress;
  }



  static Future<void> getAddressPlace() async {
    
    // String urlGG = "https://rsapi.goong.io/Geocode?latlng=21.013715429594125,%20105.79829597455202&api_key&api_key=mJK2gk9TYjdZdKi2dxD0kbxsn0a97Qe559G4xsnU";
    // String urlPlace = "https://rsapi.goong.io/geocode?address=Trạm Xăng Dầu Minh Hưng&api_key=mJK2gk9TYjdZdKi2dxD0kbxsn0a97Qe559G4xsnU";
    // String urlSearch = "https://rsapi.goong.io/Place/AutoComplete?api_key=mJK2gk9TYjdZdKi2dxD0kbxsn0a97Qe559G4xsnU&input=Hồ trị an, Tôn Đức Thắng, TT. Vĩnh An, Vĩnh Cửu, Đồng Nai, Việt Nam";


    String urlPlace = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=1500&type=restaurant&keyword=cruise&key=${Environment.apiKey}";
    var res = await http.get(Uri.parse(urlPlace));
    var result = jsonDecode(res.body);
    print(result);
  }

  static Future<Direction> getDirectionTwoPoint(LatLng source, LatLng des) async {
    String url = "https://rsapi.goong.io/Direction?origin=${source.latitude},${source.longitude}&destination=${des.latitude},${des.longitude}&vehicle=bike&api_key=mJK2gk9TYjdZdKi2dxD0kbxsn0a97Qe559G4xsnU";

    var res = await http.get(Uri.parse(url));
    var result = jsonDecode(res.body);
    return Direction.fromJson(result);
  }
}

class Direction {
  final List<Route> routes;

  Direction({required this.routes});

  factory Direction.fromJson(Map<String, dynamic> json) =>
   Direction(
    routes: List<Route>.from(json["routes"].map((x) => Route.fromJson(x))));

}

class Route {
  final OverviewPolyLine overviewPolyline;
  final List<PointLatLng> polylinePoints;
  final List<Leg> legs; 
  Route({required this.overviewPolyline,
   required this.legs, required this.polylinePoints
  });

 factory Route.fromJson(Map<String, dynamic> json) => Route(
  overviewPolyline: OverviewPolyLine.fromJson(json['overview_polyline']), 
  legs: List<Leg>.from(json['legs'].map(((x) => Leg.fromJson(x)))),
  polylinePoints: PolylinePoints().decodePolyline(json['overview_polyline']['points']),
  );
}

class Leg {
  final String distance;
  final String duration;
  final String endAddress;
  final String startAddress;

  Leg({required this.distance, required this.duration, required this.endAddress, required this.startAddress});

  factory Leg.fromJson(Map<String, dynamic> json) => Leg(
    distance: json['distance']['text'], 
    duration: json['duration']['text'], 
    endAddress: json['end_address'], 
    startAddress: json['start_address']);
}

class OverviewPolyLine {
  final String point;

  OverviewPolyLine({required this.point});

  factory OverviewPolyLine.fromJson(Map<String, dynamic> json) => OverviewPolyLine(
    point: json['points'],);
}

// open' |'block'|'cancel'| 'pending'|'is_beginning'|'completed' | 'reopen'
final Map<String, String> StatusTrip = {
  "open": "open",
  "begin": "is_beginning",
  "cancel": "cancel",
  "pending": "pending",
  "completed": "completed"
};