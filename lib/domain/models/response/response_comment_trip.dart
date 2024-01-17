import 'dart:convert';
import 'dart:ffi';

ResponseCommentsTrip responseCommentsFromJson(String str) =>
    ResponseCommentsTrip.fromJson(json.decode(str));

String responseCommentsToJson(ResponseCommentsTrip data) =>
    json.encode(data.toJson());

class ResponseCommentsTrip {
  ResponseCommentsTrip({
    required this.resp,
    required this.message,
    required this.comments,
  });

  bool resp;
  String message;
  List<CommentTrip> comments;

  factory ResponseCommentsTrip.fromJson(Map<String, dynamic> json) =>
      ResponseCommentsTrip(
        resp: json["resp"],
        message: json["message"],
        comments: List<CommentTrip>.from(
            json["comments"].map((x) => CommentTrip.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "resp": resp,
        "message": message,
        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
      };
}

class CommentTrip {


  CommentTrip({
    required this.uid,
    required this.comment,
    // required this.createdAt,
    // required this.personUid,
    required this.achievement,
    required this.fullname,
    required this.isLeader,
    required this.scorePrestige,
    required this.avatar,
  });

  int uid;
  String comment;
  String fullname;
  // DateTime createdAt;
  String achievement;
  int isLeader;
  // String personUid;
  double scorePrestige;
  // String postUid;
  String avatar;
  // trip_comment.uid,trip_comment.comment, person.fullname,person.achievement,person.is_leader,person.score_prestige,person.image as avatar
  factory CommentTrip.fromJson(Map<String, dynamic> json) => CommentTrip(
        uid: json["uid"] ?? 0,
        comment: json["comment"] ?? '',
        isLeader: json["is_leader"] ?? 0,
        // createdAt: DateTime.parse(json["created_at"]),
        // personUid: json["person_uid"],
        achievement: json["achievement"] ?? '',
        fullname: json["fullname"] ?? '',
        scorePrestige: json['score_prestige'] + 0.0 ?? 0.toDouble(),
        avatar: json["avatar"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "comment": comment,
        "is_leader": isLeader,
        'achievement': achievement,
        'score_prestige': scorePrestige,
        "fullname": fullname,
        "avatar": avatar,
        // "created_at": createdAt.toIso8601String(),
        // "person_uid": personUid,
        // "post_uid": postUid,

      };
}





class ResponseCommentsTripCompleted {
  ResponseCommentsTripCompleted({
    required this.resp,
    required this.message,
    required this.comments,
  });

  bool resp;
  String message;
  List<TripComment> comments;

  factory ResponseCommentsTripCompleted.fromJson(Map<String, dynamic> json) =>
      ResponseCommentsTripCompleted(
        resp: json["resp"],
        message: json["message"],
        comments: List<TripComment>.from(
            json["comments"].map((x) => TripComment.fromJson(x))),
      );

  // Map<String, dynamic> toJson() => {
  //       "resp": resp,
  //       "message": message,
  //       "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
  //     };
}

class TripComment {
  //  trip_members.uid,trip_members.trip_comment, trip_members.trip_rate,person.fullname,person.achievement,person.is_leader,person.score_prestige,person.image as avatar
  final String uid;
  final String tripComment;
  final double tripRate;
  final String fullname;
  final String achievement;
  final int isLeader;
  final double scorePrestige;
  final String avatar;

  TripComment(
      {required this.uid,
      required this.tripComment,
      required this.tripRate,
      required this.fullname,
      required this.achievement,
      required this.isLeader,
      required this.scorePrestige,
      required this.avatar});

  factory TripComment.fromJson(Map<String, dynamic> json) => TripComment(
      uid: json['uid'] ?? '',
      tripComment: json['trip_comment'] ?? '',
      tripRate: json['trip_rate'] + 0.0 ?? 0.0.toDouble(),
      fullname: json['fullname'] ?? '',
      achievement: json['achievement'] ?? '',
      isLeader: json['is_leader'] ?? 0,
      scorePrestige: json['score_prestige'] + 0.0 ?? 0.toDouble(),
      avatar: json['avatar']);
}
