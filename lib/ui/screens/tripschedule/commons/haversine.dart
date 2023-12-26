import 'dart:math';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Haversine {
  double R = 6371.0; // Bán kính trung bình của Trái Đất (đơn vị: km)
  double radians(double degree) {
    return degree * (pi / 180);
  } 

  double haversineLatLng(LatLng location1, LatLng location2) {
    double lat1 = radians(location1.latitude);
    double lon1 = radians(location1.longitude);
    double lat2 = radians(location2.latitude);
    double lon2 = radians(location2.longitude);
    double dlat = lat2 - lat1;
    double dlon = lon2 - lon1;
    double a =
        pow(sin(dlat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dlon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }

  double haversinePointLatLng(PointLatLng location1, PointLatLng location2) {
    double lat1 = radians(location1.latitude);
    double lon1 = radians(location1.longitude);
    double lat2 = radians(location2.latitude);
    double lon2 = radians(location2.longitude);

    double dlat = lat2 - lat1;
    double dlon = lon2 - lon1;

    double a =
        pow(sin(dlat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dlon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  } 
}

Haversine haversine =Haversine();