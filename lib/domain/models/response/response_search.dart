import 'dart:convert';

ResponseSearch responseSearchFromJson(String str) => ResponseSearch.fromJson(json.decode(str));

String responseSearchToJson(ResponseSearch data) => json.encode(data.toJson());

class ResponseSearch {

    ResponseSearch({
        required this.resp,
        required this.message,
        required this.userFind,
    });

    bool resp;
    String message;
    List<UserFind> userFind;

    factory ResponseSearch.fromJson(Map<String, dynamic> json) => ResponseSearch(
        resp: json["resp"],
        message: json["message"],
        userFind: List<UserFind>.from(json["userFind"].map((x) => UserFind.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "resp": resp,
        "message": message,
        "userFind": List<dynamic>.from(userFind.map((x) => x.toJson())),
    };
}

class UserFind {
  
    UserFind({
        required this.uid,
        required this.fullname,
        required this.avatar,
        required this.username,
    });

    String uid;
    String fullname;
    String avatar;
    String username;

    factory UserFind.fromJson(Map<String, dynamic> json) => UserFind(
        uid: json["uid"],
        fullname: json["fullname"],
        avatar: json["avatar"],
        username: json["username"],
    );

    Map<String, dynamic> toJson() => {
        "uid": uid,
        "fullname": fullname,
        "avatar": avatar,
        "username": username,
    };
}




class ResponseSearchByKeyWord {
  ResponseSearchByKeyWord({
    required this.resp,
    required this.message,
    required this.users,
    required this.trips,
    required this.posts,
  });

  bool resp;
  String message;
  List<DataByKeyWord> users;
  List<DataByKeyWord> trips;
  List<DataByKeyWord> posts;

  factory ResponseSearchByKeyWord.fromJson(Map<String, dynamic> json) => ResponseSearchByKeyWord(
        resp: json["resp"],
        message: json["message"],
        users: List<DataByKeyWord>.from(
            json["users"].map((x) => DataByKeyWord.fromJson(x))),
        trips: List<DataByKeyWord>.from(
            json["trips"].map((x) => DataByKeyWord.fromJson(x))),
        posts: List<DataByKeyWord>.from(
            json["posts"].map((x) => DataByKeyWord.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "resp": resp,
        "message": message,
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
        "trips": List<dynamic>.from(trips.map((x) => x.toJson())),
        "posts": List<dynamic>.from(posts.map((x) => x.toJson())),
      };
}


class DataByKeyWord {
  DataByKeyWord({
    required this.uid,
    required this.name,
    required this.image,
    required this.type,
  });

  String uid;
  String name;
  String image;
  String type;

  factory DataByKeyWord.fromJson(Map<String, dynamic> json) => DataByKeyWord(
        uid: json["uid"] ?? "",
        name: json["name"] ?? '',
        image: json["image"] ?? "",
        type: json["type"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "image": image,
        "type": type,
      };
}
