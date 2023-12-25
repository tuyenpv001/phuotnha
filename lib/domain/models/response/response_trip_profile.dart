import 'dart:convert';

ResponseTripProfile responseTripProfileFromJson(String str) => ResponseTripProfile.fromJson(json.decode(str));

String responseTripProfileToJson(ResponseTripProfile data) => json.encode(data.toJson());

class ResponseTripProfile {

    ResponseTripProfile({
        required this.resp,
        required this.message,
        required this.trip,
    });

    bool resp;
    String message;
    List<TripProfile> trip;

    factory ResponseTripProfile.fromJson(Map<String, dynamic> json) => ResponseTripProfile(
        resp: json["resp"],
        message: json["message"],
        trip: List<TripProfile>.from(json["trip"].map((x) => TripProfile.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "resp": resp,
        "message": message,
        "trip": List<dynamic>.from(trip.map((x) => x.toJson())),
    };
}

class TripProfile {

    TripProfile({
        required this.uid,
        required this.isComment,
        required this.typePrivacy,
        required this.createdAt,
        required this.images,
    });

    String uid;
    int isComment;
    String typePrivacy;
    DateTime createdAt;
    String images;

    factory TripProfile.fromJson(Map<String, dynamic> json) => TripProfile(
        uid: json["uid"] ?? '',
        isComment: json["is_comment"] ?? -0,
        typePrivacy: json["type_privacy"] ?? '',
        createdAt: DateTime.parse(json["created_at"] ?? json['']),
        images: json["images"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "uid": uid,
        "is_comment": isComment,
        "type_privacy": typePrivacy,
        "created_at": createdAt.toIso8601String(),
        "images": images,
    };
}
