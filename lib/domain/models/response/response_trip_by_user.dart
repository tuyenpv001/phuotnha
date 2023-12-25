import 'dart:convert';

ResponseTripByUser responseTripByUserFromJson(String str) => ResponseTripByUser.fromJson(json.decode(str));

String responseTripByUserToJson(ResponseTripByUser data) => json.encode(data.toJson());

class ResponseTripByUser {

    ResponseTripByUser({
        required this.resp,
        required this.message,
        required this.tripUser,
    });

    bool resp;
    String message;
    List<TripUser> tripUser;

    factory ResponseTripByUser.fromJson(Map<String, dynamic> json) => ResponseTripByUser(
        resp: json["resp"],
        message: json["message"],
        tripUser: List<TripUser>.from(json["tripUser"].map((x) => TripUser.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "resp": resp,
        "message": message,
        "tripUser": List<dynamic>.from(tripUser.map((x) => x.toJson())),
    };
}

class TripUser {

    TripUser({
        required this.tripUid,
        required this.isComment,
        required this.typePrivacy,
        required this.createdAt,
        required this.personUid,
        required this.username,
        required this.avatar,
        required this.images,
        required this.countComment,
        required this.countLikes,
        required this.isLike,
    });

    String tripUid;
    int isComment;
    String typePrivacy;
    DateTime createdAt;
    String personUid;
    String username;
    String avatar;
    String images;
    int countComment;
    int countLikes;
    int isLike;

    factory TripUser.fromJson(Map<String, dynamic> json) => TripUser(
        tripUid: json["trip_uid"],
        isComment: json["is_comment"],
        typePrivacy: json["type_privacy"],
        createdAt: DateTime.parse(json["created_at"]),
        personUid: json["person_uid"],
        username: json["username"],
        avatar: json["avatar"],
        images: json["images"],
        countComment: json["count_comment"],
        countLikes: json["count_likes"],
        isLike: json["is_like"],
    );

    Map<String, dynamic> toJson() => {
        "trip_uid": tripUid,
        "is_comment": isComment,
        "type_privacy": typePrivacy,
        "created_at": createdAt.toIso8601String(),
        "person_uid": personUid,
        "username": username,
        "avatar": avatar,
        "images": images,
        "count_comment": countComment,
        "count_likes": countLikes,
        "is_like": isLike,
    };
}
