import 'dart:convert';
import 'dart:ffi';

import 'package:social_media/domain/models/response/response_trip.dart';

ResponseMarkersTrip responseCommentsFromJson(String str) =>
    ResponseMarkersTrip.fromJson(json.decode(str));

// String responseCommentsToJson(ResponseMarkersTrip data) =>
//     json.encode(data.toJson());

class ResponseMarkersTrip {
  ResponseMarkersTrip({
    required this.resp,
    required this.message,
    required this.markers,
  });

  bool resp;
  String message;
  List<TripRecommend> markers;

  factory ResponseMarkersTrip.fromJson(Map<String, dynamic> json) =>
      ResponseMarkersTrip(
        resp: json["resp"],
        message: json["message"],
        markers: List<TripRecommend>.from(
            json["markers"].map((x) => TripRecommend.fromJson(x))),
      );

  // Map<String, dynamic> toJson() => {
  //       "resp": resp,
  //       "message": message,
  //       "markers": List<dynamic>.from(markers.map((x) => x.toJson())),
  //     };
}

