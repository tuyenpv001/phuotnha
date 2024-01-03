import 'dart:convert';

ResponseTripByUser responseTripByUserFromJson(String str) => ResponseTripByUser.fromJson(json.decode(str));

String responseTripByUserToJson(ResponseTripByUser data) => json.encode(data.toJson());

class ResponseTripByUser {

    ResponseTripByUser({
        required this.resp,
        required this.message,
        required this.trips,
    });

    bool resp;
    String message;
    List<TripUser> trips;

    factory ResponseTripByUser.fromJson(Map<String, dynamic> json) => ResponseTripByUser(
        resp: json["resp"],
        message: json["message"],
        trips: List<TripUser>.from(json["trips"].map((x) => TripUser.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "resp": resp,
        "message": message,
        "tripUser": List<dynamic>.from(trips.map((x) => x.toJson())),
    };
}

class TripUser {

    TripUser({
    required this.uid,
    required this.title,
    required this.image,
    required this.desscription,
    required this.status,
    required this.dateStart,
    required this.dateEnd,
    required this.tripMember,
    required this.totalMemberJoined,
    });

  final String uid;
  final String title;
  final String image;
  final String desscription;
  final String status;
  final DateTime dateStart;
  final DateTime dateEnd;
  final int tripMember;
  final int totalMemberJoined;



    factory TripUser.fromJson(Map<String, dynamic> json) => TripUser(
        uid: json["uid"],
        image: json["image"] ?? '',
        desscription: json['trip_description'] ?? '',
        tripMember: json['trip_member'] ?? 0,
        status: json['trip_status'],
        title: json['trip_title'],
        totalMemberJoined: json['totalMemberJoined'],
        dateStart:  DateTime.parse(json["trip_date_start"]).add(const Duration(days: 1)),
        dateEnd:  DateTime.parse(json["trip_date_end"]).add(const Duration(days: 1))
    );

    Map<String, dynamic> toJson() => {
      "uid": uid,
      "trip_title": title,
      "trip_description":desscription,
    "trip_date_start": dateStart,
    "trip_date_end": dateEnd,
    // trip_from: 'Ngã tư Thủ Đức',
    // trip_to: 'Biển Cần Giờ',
    "trip_member": tripMember,
    "trip_status": status,
    // created_at: 2023-12-25T07:01:31.000Z,
    // updated_at: 2023-12-25T07:01:31.000Z,
    "image": image,
    "totalMemberJoined": totalMemberJoined
    };
}


// uid: '349a5c74-e31b-4cb3-87aa-e3be559fa824',
//     user_uid: '88fdc431-9c21-481f-823c-c0942d308249',
//     trip_title: 'Tắm biển Cần Giờ',
//     trip_description: 'Chuyến đi tắm biển giải tress',
//     trip_date_start: 2023-12-24T17:00:00.000Z,
//     trip_date_end: 2023-12-26T17:00:00.000Z,
//     trip_from: 'Ngã tư Thủ Đức',
//     trip_to: 'Biển Cần Giờ',
//     trip_member: 2,
//     trip_status: 'open',
//     created_at: 2023-12-25T07:01:31.000Z,
//     updated_at: 2023-12-25T07:01:31.000Z,
//     image: 'ae90ed4d-469c-49d7-994a-22524f85f5a7.jpg',
//     totalMemberJoined: 1