class ResponseTrip {
  final bool resp;
  final String message;
  final List<Trip> trips;

  ResponseTrip({
    required this.resp,
    required this.message,
    required this.trips,
  });

  factory ResponseTrip.fromJson(Map<String, dynamic> json) => ResponseTrip(
        resp: json["resp"],
        message: json["message"],
        trips: List<Trip>.from(json["trips"].map((x) => Trip.fromJson(x))),
      );
}

class Trip {
  final String title;
  final String description;
  final String tripUid;
  final String tripTo;
  final String tripFrom;
  final DateTime createdAt;
  final DateTime dateStart;
  final DateTime dateEnd;
  final String personUid;
  final String username;
  final int isLeader;
  final String avatar;
  final String userAchievement;
  final String images;
  final int tripMember;
  final int totalMemberJoined;
  final int isClose;
  final int isJoined;
  final int isOwner;

  Trip(
      {required this.tripUid,
      required this.createdAt,
      required this.personUid,
      required this.username,
      required this.tripTo,
      required this.tripFrom,
      required this.avatar,
      required this.images,
      required this.isLeader,
      required this.userAchievement,
      required this.tripMember,
      required this.totalMemberJoined,
      required this.isClose,
      required this.isJoined,
      required this.isOwner,
      required this.title,
      required this.description,
      required this.dateStart,
      required this.dateEnd});

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
      tripUid: json["trip_uid"],
      title: json["trip_title"],
      tripFrom: json["trip_from"],
      tripTo: json["trip_to"],
      description: json["trip_title"],
      dateStart: DateTime.parse(json["trip_date_start"]).add(const Duration(days: 1)),
      dateEnd: DateTime.parse(json["trip_date_end"]).add(const Duration(days: 1)),
      createdAt: DateTime.parse(json["created_at"]),
      personUid: json["userID"],
      username: json["fullname"],
      isLeader: json["is_leader"],
      userAchievement: json["userAchievement"],
      avatar: json["image"],
      images: json["tripimages"] ?? "",
      tripMember: json["trip_member"],
      totalMemberJoined: json["totalMemberJoined"],
      isClose: json["isClose"],
      isJoined: json["isJoined"],
      isOwner: json["isOwner"]);
}

// {
//   resp: true,
//   message: 'Get detail trips',
//   trips: [
//     {
//       trip_uid: '13e3e8ce-c1a4-4126-9395-709815aa1e07',
//       user_uid: '88fdc431-9c21-481f-823c-c0942d308249',
//       trip_title: 'sgsjs',
//       trip_description: 'bssjsn',
//       trip_from: 'shsnsb',
//       trip_to: 'sbsnaj',
//       trip_date_start: 2023-12-15T17:00:00.000Z,
//       trip_date_end: 2023-12-17T17:00:00.000Z,
//       trip_status: 'open',
//       trip_member: 2,
//       created_at: 2023-12-15T10:04:30.000Z,
//       fullname: 'Phan Tuyển',
//       userID: '88fdc431-9c21-481f-823c-c0942d308249',
//       is_leader: 0,
//       image: 'avatar-default.png',
//       userAchievement: '',
//       totalMemberJoined: 0,
//       isClose: 0,
//       isJoined: 0,
//       isOwner: 1
//     }
//   ],
//   images: [
//     {
//       uid: 'e6542650-95a9-4c44-bc68-3a24089765bb',
//       trip_uid: '13e3e8ce-c1a4-4126-9395-709815aa1e07',
//       trip_image_url: '4832e008-14f1-48f3-9ea4-15060cc19d74.jpg'
//     }
//   ],
//   tripRecommends: [],
//   tripMembers: [],
//   imagesdb: undefined
// }

class ResponseTripDetail {
  final bool resp;
  final String message;
  final List<TripDetail> trip;
  final List<TripImage> images;
  final List<TripRecommend> tripRecommends;
  final List<TripMember> tripMembers;

  ResponseTripDetail({
    required this.resp,
    required this.message,
    required this.trip,
    required this.images,
    required this.tripRecommends,
    required this.tripMembers,
  });

  factory ResponseTripDetail.fromJson(Map<String, dynamic> json) =>
      ResponseTripDetail(
        resp: json["resp"],
        message: json["message"],
        trip: List<TripDetail>.from(
            json["trips"].map((x) => TripDetail.fromJson(x))),
        images: List<TripImage>.from(
            json["images"].map((x) => TripImage.fromJson(x))),
        tripRecommends: List<TripRecommend>.from(
            json["tripRecommends"].map((x) => TripRecommend.fromJson(x))),
        tripMembers: List<TripMember>.from(
            json["tripMembers"].map((x) => TripMember.fromJson(x))),
      );
}

class TripRecommend {
// `uid`, `trip_uid`, `lat`, `lng`, `address_short`, `address_detail`, `isGasStation`, `isRepairMotobike`
  final String uid;
  final String tripUid;
  final double lat;
  final double lng;
  final String addressShort;
  final String addressDetail;
  final int isGasStation;
  final int isRepairMotobike;

  TripRecommend({required this.uid, required this.tripUid, required this.lat, required this.lng, required this.addressShort, required this.addressDetail, required this.isGasStation, required this.isRepairMotobike});

  factory TripRecommend.fromJson(Map<String, dynamic> json) => TripRecommend(
    uid: json['uid'], 
    tripUid: json['trip_uid'], 
    lat: json['lat'] ?? 0.0, 
    lng: json['lng'] ?? 0.0, 
    addressShort: json['address_short'] ?? '', 
    addressDetail: json['address_detail'] ?? '', 
    isGasStation: json['isGasStation'] ?? 0, 
    isRepairMotobike: json['isRepairMotobike'] ?? 0);


//  trip_recommend.uid as trip_recommend_uid, trip_recommend.trip_point, trip_recommend.trip_des_point
  // final String id;
  // final String point;
  // final String desPoint;

  // TripRecommend({
  //   required this.id,
  //   required this.point,
  //   required this.desPoint,
  // });

  // factory TripRecommend.fromJson(Map<String, dynamic> json) => TripRecommend(
  //     id: json["trip_recommend_uid"],
  //     point: json["trip_point"],
  //     desPoint: json["trip_des_point"]);
}

class TripMember {
  // person.fullname,person.fullname as avatar, person.achievemen
  final String fullname;
  final String avatar;
  final String achievemen;
  final String role;

  TripMember({
    required this.fullname,
    required this.avatar,
    required this.achievemen,
    required this.role,
  });

  factory TripMember.fromJson(Map<String, dynamic> json) => TripMember(
      fullname: json["fullname"] ?? '',
      avatar: json["avatar"] ?? '',
      achievemen: json["achievemen"] ?? 'O',
      role: json["role"] ?? 'member',
      );
}

class TripImage {
  // trip_images.uid,trip_images.trip_image_url
  final String uid;
  final String tripImgUrl;

  TripImage({required this.uid, required this.tripImgUrl});

  factory TripImage.fromJson(Map<String, dynamic> json) =>
      TripImage(uid: json["uid"], tripImgUrl: json["trip_image_url"]);
}

class TripDetail {
  final String title;
  final String description;
  final String tripUid;
  final String tripTo;
  final String tripFrom;
  final DateTime createdAt;
  final DateTime dateStart;
  final DateTime dateEnd;
  final String personUid;
  final String username;
  final int isLeader;
  final String avatar;
  final String userAchievement;
  final int tripMember;
  final int totalMemberJoined;
  final int isClose;
  final int isJoined;
  final int isOwner;

  TripDetail(
      {required this.tripUid,
      required this.createdAt,
      required this.personUid,
      required this.username,
      required this.tripTo,
      required this.tripFrom,
      required this.avatar,
      required this.isLeader,
      required this.userAchievement,
      required this.tripMember,
      required this.totalMemberJoined,
      required this.isClose,
      required this.isJoined,
      required this.isOwner,
      required this.title,
      required this.description,
      required this.dateStart,
      required this.dateEnd});

  factory TripDetail.fromJson(Map<String, dynamic> json) => TripDetail(
      tripUid: json["trip_uid"] ?? '',
      title: json["trip_title"] ?? '',
      tripFrom: json["trip_from"] ?? '',
      tripTo: json["trip_to"] ?? '',
      description: json["trip_description"] ?? "",
      dateStart: DateTime.parse(json["trip_date_start"]),
      dateEnd: DateTime.parse(json["trip_date_end"]),
      createdAt: DateTime.parse(json["created_at"]),
      personUid: json["userID"] ?? '',
      username: json["fullname"] ??'',
      isLeader: json["is_leader"] ?? 0,
      userAchievement: json["userAchievement"] ?? 'O',
      avatar: json["image"] ?? '',
      tripMember: json["trip_member"] ?? 0,
      totalMemberJoined: json["totalMemberJoined"] ?? 0,
      isClose: json["isClose"] ?? 0,
      isJoined: json["isJoined"] ?? 0,
      isOwner: json["isOwner"] ?? 0);
}

class ResponseTripSchedule {
  final bool resp;
  final String message;
  final List<TripSchedule> trips;

  ResponseTripSchedule({
    required this.resp,
    required this.message,
    required this.trips,
  });
  factory ResponseTripSchedule.fromJson(Map<String, dynamic> json) =>
      ResponseTripSchedule(
        resp: json["resp"],
        message: json["message"],
        trips: List<TripSchedule>.from(json["trips"].map((x) => TripSchedule.fromJson(x))),
      );
}


class TripSchedule {
  final String tripUid;
  final String title;
  final String tripTo;
  final String tripFrom;
  final String tripStatus;
  final DateTime createdAt;
  final DateTime dateStart;
  final DateTime dateEnd;
  final String thumbnail;
  final String fullname;
  // final int isLeader;
  final String avatar;
  final String achievement;
  final int tripMember;
  final int totalMemberJoined;
  final int isOwner;

  TripSchedule( 
      {required this.tripUid,
      required this.createdAt,
      required this.tripTo,
      required this.tripFrom,
      required this.avatar,
      // required this.isLeader,
      required this.tripMember,
      required this.totalMemberJoined,
      required this.isOwner,
      required this.title,
      required this.dateStart,
      required this.tripStatus,
      required this.thumbnail,
      required this.fullname,
      required this.achievement,
      required this.dateEnd});

// trip_uid,trip.trip_title,trip.trip_from,trip.trip_to,trip.trip_date_start, trip.trip_date_end,trip.trip_status,trip.trip_member,trip.created_at,trip_images.trip_image_url as thumbnail, person.fullname, person.image as avatar, person.achievement, (SELECT COUNT(trip_members.trip_uid) FROM trip_members WHERE trip_members.trip_uid = trip.uid) as totalMemberJoined, (SELECT IF(trip.user_uid = ID_USER, 1,0)) as isOwner
  factory TripSchedule.fromJson(Map<String, dynamic> json) => TripSchedule(
      tripUid: json["trip_uid"],
      title: json["trip_title"],
      tripFrom: json["trip_from"],
      tripTo: json["trip_to"],
      dateStart: DateTime.parse(json["trip_date_start"]),
      dateEnd: DateTime.parse(json["trip_date_end"]),
      createdAt: DateTime.parse(json["created_at"]),
      // isLeader: json["is_leader"],
      avatar: json["avatar"] ?? "avatar_default.png",
      tripMember: json["trip_member"] ?? 0,
      totalMemberJoined: json["totalMemberJoined"] ?? 0,
      isOwner: json["isOwner"] ?? 0,
      tripStatus: json["trip_status"] ?? '',
      thumbnail: json["thumbnail"] ?? "cover_default.jpg",
      fullname: json["fullname"] ?? "",
      achievement: json["achievement"] ?? "");
}


class ResponseTripDetailMember {
  final bool resp;
  final String message;
  final List<TripMemberDetail> tripMembers;

  ResponseTripDetailMember({
    required this.resp,
    required this.message,
    required this.tripMembers,
  });

  factory ResponseTripDetailMember.fromJson(Map<String, dynamic> json) =>
      ResponseTripDetailMember(
        resp: json["resp"],
        message: json["message"],
        tripMembers: List<TripMemberDetail>.from(
            json["tripMembers"].map((x) => TripMemberDetail.fromJson(x))),
      );
}


class TripMemberDetail {
  final String tripMemberUid;
  final String tripUid;
  final String personUid;
  final String fullname;
  final String avatar;
  final String achievement;
  final String userRole;
  final int isMember;
  final int isPermissionChangeRole;
  final String tripLeader;

  TripMemberDetail({
    required this.fullname,
    required this.avatar,
    required this.achievement,
    required this.tripMemberUid,
    required this.tripUid,
    required this.personUid,
    required this.userRole, 
    required this.isMember, 
    required this.isPermissionChangeRole,
    required this.tripLeader
  });
//   SELECT trip_members.uid as trip_member_uid, trip_members.trip_uid,trip_members.person_uid,trip_members.trip_role as userRole,
// person.fullname,person.image as avatar, person.achievement
  factory TripMemberDetail.fromJson(Map<String, dynamic> json) => TripMemberDetail(
        fullname: json["fullname"] ?? '',
        avatar: json["avatar"] ?? 'avatar_default.png',
        achievement: json["achievemen"] ?? '',
        userRole: json["userRole"] ?? '',
        tripMemberUid:json["trip_member_uid"] ?? '',
        personUid: json["person_uid"] ?? '',
        tripUid: json["trip_uid"] ?? '',
        isMember: json["isMember"] ?? 0,
        isPermissionChangeRole: json["isPermissionChangeRole"] ?? 0,
        tripLeader: json["trip_leader"] ?? "",
      );
}
