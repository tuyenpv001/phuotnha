import 'dart:convert';

ResponseListMessages responseListMessagesFromJson(String str) => ResponseListMessages.fromJson(json.decode(str));

String responseListMessagesToJson(ResponseListMessages data) => json.encode(data.toJson());

class ResponseListMessages {

    ResponseListMessages({
        required this.resp,
        required this.message,
        required this.listMessage,
    });

    bool resp;
    String message;
    List<ListMessage> listMessage;

    factory ResponseListMessages.fromJson(Map<String, dynamic> json) => ResponseListMessages(
        resp: json["resp"],
        message: json["message"],
        listMessage: List<ListMessage>.from(json["listMessage"].map((x) => ListMessage.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "resp": resp,
        "message": message,
        "listMessage": List<dynamic>.from(listMessage.map((x) => x.toJson())),
    };
}

class ListMessage {

    ListMessage({
        required this.uidMessages,
        required this.sourceUid,
        required this.targetUid,
        required this.message,
        required this.createdAt,
    });

    String uidMessages;
    String sourceUid;
    String targetUid;
    String message;
    DateTime createdAt;

    factory ListMessage.fromJson(Map<String, dynamic> json) => ListMessage(
        uidMessages: json["uid_messages"],
        sourceUid: json["source_uid"],
        targetUid: json["target_uid"],
        message: json["message"],
        createdAt: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "uid_messages": uidMessages,
        "source_uid": sourceUid,
        "target_uid": targetUid,
        "message": message,
        "created_at": createdAt.toIso8601String(),
    };
}


class ResponseListMessagesTrip {
  ResponseListMessagesTrip({
    required this.resp,
    required this.message,
    required this.listMessage,
  });

  bool resp;
  String message;
  List<ListMessageTrip> listMessage;

  factory ResponseListMessagesTrip.fromJson(Map<String, dynamic> json) =>
      ResponseListMessagesTrip(
        resp: json["resp"],
        message: json["message"],
        listMessage: List<ListMessageTrip>.from(
            json["listMessage"].map((x) => ListMessageTrip.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "resp": resp,
        "message": message,
        "listMessage": List<dynamic>.from(listMessage.map((x) => x.toJson())),
      };
}

class ListMessageTrip {
  ListMessageTrip({
    required this.uidMessages,
    required this.sourceUid,
    required this.targetUid,
    required this.message,
    required this.createdAt,
  });

  String uidMessages;
  String sourceUid;
  String targetUid;
  String message;
  DateTime createdAt;
// `uid_message_trip`, `source_uid`, `target_trip_uid`, `message`, `created_at`
  factory ListMessageTrip.fromJson(Map<String, dynamic> json) => ListMessageTrip(
        uidMessages: json["uid_message_trip"],
        sourceUid: json["source_uid"],
        targetUid: json["target_trip_uid"],
        message: json["message"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "uid_message_trip": uidMessages,
        "source_uid": sourceUid,
        "target_trip_uid": targetUid,
        "message": message,
        "created_at": createdAt.toIso8601String(),
      };
}


class ResponseCallByUser {
  ResponseCallByUser({
    required this.resp,
    required this.message,
    required this.caller,
  });

  bool resp;
  String message;
  CallByUserRes caller;

  factory ResponseCallByUser.fromJson(Map<String, dynamic> json) =>
      ResponseCallByUser(
        resp: json["resp"],
        message: json["message"],
        caller:  CallByUserRes.fromJson(json["caller"][0]),
      );

  // Map<String, dynamic> toJson() => {
  //       "resp": resp,
  //       "message": message,
  //       "listMessage": List<dynamic>.from(listMessage.map((x) => x.toJson())),
  //     };
}

class CallByUserRes {
  // uid,caller_uid,receiver_id,call_name,receiver_name,caller_avatar,receiver_avatar,channel_id,channel_name,is_disabled
  final String uid;
  final String calleruid;
  final String receiverid;
  final String callname;
  final String receivername;
  final String calleravatar;
  final String receiveravatar;
  final String channelid;
  final String channelname;
  int isdisabled;

  CallByUserRes( {
    required this.uid,
    required this.calleruid,
    required this.receiverid,
    required this.callname,
    required this.receivername,
    required this.calleravatar,
    required this.receiveravatar,
    required this.channelid,
    required this.channelname,
    required this.isdisabled
  });


 // ,,,,,,,,,
   factory CallByUserRes.fromJson(Map<String, dynamic> json) =>
      CallByUserRes(
        uid: json["uid"],
        calleruid: json["caller_uid"],
        callname: json["call_name"],
        calleravatar: json["caller_avatar"],
        receiverid: json["receiver_id"],
        receivername: json["receiver_name"],
        receiveravatar: json["receiver_avatar"],
        channelid: json["channel_id"],
        channelname: json["channel_name"],
        isdisabled: json["is_disabled"],
      );
}