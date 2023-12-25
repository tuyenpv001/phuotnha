import 'dart:convert';

ResponseTripSaved responseTripSavedFromJson(String str) => ResponseTripSaved.fromJson(json.decode(str));

String responseTripSavedToJson(ResponseTripSaved data) => json.encode(data.toJson());

class ResponseTripSaved {

    ResponseTripSaved({
        required this.resp,
        required this.message,
        required this.listSavedTrip,
    });

    bool resp;
    String message;
    List<ListSavedTrip> listSavedTrip;

    factory ResponseTripSaved.fromJson(Map<String, dynamic> json) => ResponseTripSaved(
        resp: json["resp"],
        message: json["message"],
        listSavedTrip: List<ListSavedTrip>.from(json["listSavedTrip"].map((x) => ListSavedTrip.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "resp": resp,
        "message": message,
        "listSavedTrip": List<dynamic>.from(listSavedTrip.map((x) => x.toJson())),
    };
}

class ListSavedTrip {
  
    ListSavedTrip({
        required this.tripSaveUid,
        required this.tripUid,
        required this.personUid,
        required this.dateSave,
        required this.avatar,
        required this.username,
        required this.images,
    });

    String tripSaveUid;
    String tripUid;
    String personUid;
    DateTime dateSave;
    String avatar;
    String username;
    String images;

    factory ListSavedTrip.fromJson(Map<String, dynamic> json) => ListSavedTrip(
        tripSaveUid: json["trip_save_uid"],
        tripUid: json["trip_uid"],
        personUid: json["person_uid"],
        dateSave: DateTime.parse(json["date_save"]),
        avatar: json["avatar"],
        username: json["username"],
        images: json["images"],
    );

    Map<String, dynamic> toJson() => {
        "trip_save_uid": tripSaveUid,
        "trip_uid": tripUid,
        "person_uid": personUid,
        "date_save": dateSave.toIso8601String(),
        "avatar": avatar,
        "username": username,
        "images": images,
    };
}
