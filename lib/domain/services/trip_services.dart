import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:social_media/data/env/env.dart';
import 'package:social_media/data/storage/secure_storage.dart';
import 'package:social_media/domain/models/response/default_response.dart';
import 'package:social_media/domain/models/response/response_comments.dart';
import 'package:social_media/domain/models/response/response_trip.dart';
import 'package:social_media/domain/models/response/response_trip_by_user.dart';
import 'package:social_media/domain/models/response/response_trip_profile.dart';
import 'package:social_media/domain/models/response/response_trip_saved.dart';

class TripServices {
  
  Future<DefaultResponse> addNewTrip(String tripTitle,
  String tripDescription,
  String tripFrom,
  String tripTo,
  String tripDateStart,
  String tripDateEnd,
  int tripMember,
  String tripStatus, List<File> images) async {
    final token = await secureStorage.readToken();

    var request = http.MultipartRequest('POST', Uri.parse('${Environment.urlApi}/trip/create-new-trip'))
      ..headers['Accept'] = 'application/json'
      ..headers['xxx-token'] = token!
      ..fields['trip_title'] = tripTitle
      ..fields['trip_description'] = tripDescription
      ..fields['trip_date_start'] = tripDateStart
      ..fields['trip_date_end'] = tripDateEnd
      ..fields['trip_from'] = tripFrom
      ..fields['trip_to'] = tripTo
      ..fields['trip_member'] = tripMember.toString()
      ..fields['trip_status'] = tripStatus;
    
    for (var image in images) {
      request.files
          .add(await http.MultipartFile.fromPath('imageTrips', image.path));
    }
    

    final response = await request.send();
    var data = await http.Response.fromStream(response);
    return DefaultResponse.fromJson(jsonDecode(data.body));
  }

  Future<List<Trip>> getAllTripHome() async {
    final token = await secureStorage.readToken();

    final resp = await http.get(
        Uri.parse('${Environment.urlApi}/trip/get-all-trips'),
        headers: {'Accept': 'application/json', 'xxx-token': token!});

    return ResponseTrip.fromJson(jsonDecode(resp.body)).trips;
  }
  Future<List<TripSchedule>> getAllTripSchedule() async {
    final token = await secureStorage.readToken();

    final resp = await http.get(
        Uri.parse('${Environment.urlApi}/trip/get-trips-schedule'),
        headers: {'Accept': 'application/json', 'xxx-token': token!});

    return ResponseTripSchedule.fromJson(jsonDecode(resp.body)).trips;
  }
    
  Future<ResponseTripDetail> getDetailTripById(String id) async {
    final token = await secureStorage.readToken();

    final resp = await http.get(
        Uri.parse('${Environment.urlApi}/trip/get-trip-by-id/' + id),
        headers: {'Accept': 'application/json', 'xxx-token': token!});

    return ResponseTripDetail.fromJson(jsonDecode(resp.body));
  }
  Future<ResponseTripDetailMember> getMemberTripById(String id) async {
  final token = await secureStorage.readToken();

    final resp = await http.get(
        Uri.parse('${Environment.urlApi}/trip/get-members-trip-by-id/' + id),
        headers: {'Accept': 'application/json', 'xxx-token': token!});

    return ResponseTripDetailMember.fromJson(jsonDecode(resp.body));
  }
  Future<ResponseLocationMember> getLocationAllMemberOfTrip(String id) async {
  final token = await secureStorage.readToken();

    final resp = await http.get(
        Uri.parse('${Environment.urlApi}/trip/get-location-members-trip-by-id/' + id),
        headers: {'Accept': 'application/json', 'xxx-token': token!});

    return ResponseLocationMember.fromJson(jsonDecode(resp.body));
  }
  Future<ResponseTripDetail> getDetailExtraTripById(String id) async {
    final token = await secureStorage.readToken();

    final resp = await http.get(
        Uri.parse('${Environment.urlApi}/trip/get-trip-by-id-extra/' + id),
        headers: {'Accept': 'application/json', 'xxx-token': token!});

    return ResponseTripDetail.fromJson(jsonDecode(resp.body));
  }

  Future<List<TripProfile>> getTripProfiles() async {
    final token = await secureStorage.readToken();

    final resp = await http.get(
        Uri.parse('${Environment.urlApi}/trip/get-trip-by-idPerson'),
        headers: {'Accept': 'application/json', 'xxx-token': token!});

    return ResponseTripProfile.fromJson(jsonDecode(resp.body)).trip;
  }

  Future<DefaultResponse> saveTripByUser(String uidTrip, String type ) async {
    final token = await secureStorage.readToken();

    final resp = await http.post(
        Uri.parse('${Environment.urlApi}/trip/save-trip'),
        headers: {'Accept': 'application/json', 'xxx-token': token!},
        body: {'trip_uid': uidTrip, 'type': type});

    return DefaultResponse.fromJson(jsonDecode(resp.body));
  }
  Future<DefaultResponse> joinTripByUser(String uidTrip, String type) async {
    final token = await secureStorage.readToken();

    final resp = await http.post(
        Uri.parse('${Environment.urlApi}/trip/join-trip'),
        headers: {'Accept': 'application/json', 'xxx-token': token!},
        body: {'trip_uid': uidTrip, 'type': type});

    return DefaultResponse.fromJson(jsonDecode(resp.body));
  }
  Future<DefaultResponse> changeStatusTrip(String uidTrip, String status) async {
    final token = await secureStorage.readToken();

    final resp = await http.post(
        Uri.parse('${Environment.urlApi}/trip/change-status-trip'),
        headers: {'Accept': 'application/json', 'xxx-token': token!},
        body: {'trip_uid': uidTrip, 'status': status});

    return DefaultResponse.fromJson(jsonDecode(resp.body));
  }
  Future<DefaultResponse> deleteTripById(String tripUid) async {
    final token = await secureStorage.readToken();

    final resp = await http.delete(
        Uri.parse('${Environment.urlApi}/trip/delete-trip/$tripUid'),
        headers: {'Accept': 'application/json', 'xxx-token': token!},);

    return DefaultResponse.fromJson(jsonDecode(resp.body));
  }
  Future<DefaultResponse> addRoleTripByUser(String uid, String tripUid,String role) async {
    final token = await secureStorage.readToken();

    final resp = await http.post(
        Uri.parse('${Environment.urlApi}/trip/add-role-user'),
        headers: {'Accept': 'application/json', 'xxx-token': token!},
        body: {'trip_member_uid': uid, 'trip_uid': tripUid, 'role': role});

    return DefaultResponse.fromJson(jsonDecode(resp.body));
  }
  Future<DefaultResponse> addCommentAndRateTripByUser(String uid, String tripUid,String tripComment, double tripRate ) async {
    final token = await secureStorage.readToken();
    final resp = await http.post(
        Uri.parse('${Environment.urlApi}/trip/rate-trip'),
        headers: {'Accept': 'application/json', 'xxx-token': token!},
        body: {'trip_member_uid': uid, 'trip_uid': tripUid, 'trip_rate': tripRate, 'trip_comment': tripComment});

    return DefaultResponse.fromJson(jsonDecode(resp.body));
  }

  Future<List<ListSavedTrip>> getListTripSavedByUser() async {
    final token = await secureStorage.readToken();

    final resp = await http.get(
        Uri.parse('${Environment.urlApi}/trip/get-list-saved-trips'),
        headers: {'Accept': 'application/json', 'xxx-token': token!});

    return ResponseTripSaved.fromJson(jsonDecode(resp.body)).listSavedTrip;
  }

  Future<List<Trip>> getAllTripsForSearch() async {
    final token = await secureStorage.readToken();

    final resp = await http.get(
        Uri.parse('${Environment.urlApi}/trip/get-all-trips-for-search'),
        headers: {'Accept': 'application/json', 'xxx-token': token!});

    return ResponseTrip.fromJson(jsonDecode(resp.body)).trips;
  }

  Future<DefaultResponse> likeOrUnlikeTrip(
      String uidTrip, String uidPerson) async {
    final token = await secureStorage.readToken();

    final resp = await http.post(
        Uri.parse('${Environment.urlApi}/trip/like-or-unlike-trip'),
        headers: {'Accept': 'application/json', 'xxx-token': token!},
        body: {'uidTrip': uidTrip, 'uidPerson': uidPerson});

    return DefaultResponse.fromJson(jsonDecode(resp.body));
  }

  Future<List<Comment>> getCommentsByUidTrip(String uidTrip) async {
    final token = await secureStorage.readToken();

    final resp = await http.get(
      Uri.parse('${Environment.urlApi}/trip/get-comments-by-idtrip/' + uidTrip),
      headers: {'Accept': 'application/json', 'xxx-token': token!},
    );

    return ResponseComments.fromJson(jsonDecode(resp.body)).comments;
  }

  Future<DefaultResponse> addNewComment(String uidTrip, String comment) async {
    final token = await secureStorage.readToken();

    final resp = await http.post(
        Uri.parse('${Environment.urlApi}/trip/add-new-comment'),
        headers: {'Accept': 'application/json', 'xxx-token': token!},
        body: {'uidTrip': uidTrip, 'comment': comment});

    return DefaultResponse.fromJson(jsonDecode(resp.body));
  }

  Future<DefaultResponse> likeOrUnlikeComment(String uidComment) async {
    final token = await secureStorage.readToken();

    final resp = await http.put(
        Uri.parse('${Environment.urlApi}/trip/like-or-unlike-comment'),
        headers: {'Accept': 'application/json', 'xxx-token': token!},
        body: {'uidComment': uidComment});

    return DefaultResponse.fromJson(jsonDecode(resp.body));
  }

  Future<List<TripUser>> listTripByUser() async {
    final token = await secureStorage.readToken();

    final resp = await http.get(
        Uri.parse('${Environment.urlApi}/trip/get-all-trip-by-user-id'),
        headers: {'Accept': 'application/json', 'xxx-token': token!});

    return ResponseTripByUser.fromJson(jsonDecode(resp.body)).trips;
  }
}

class ResponseLocationMember {
   final bool resp;
  final String message;
  final LeaderDetail leader;
  final List<LocationMember> members;
  final List<MockData> mockData;

  ResponseLocationMember({
    required this.resp,
    required this.message,
    required this.members,
    required this.leader,
    required this.mockData
  });

  factory ResponseLocationMember.fromJson(Map<String, dynamic> json) =>
      ResponseLocationMember(
        resp: json["resp"],
        message: json["message"],
        leader: LeaderDetail.fromJson(json['leader']),
        members: List<LocationMember>.from(
            json["members"].map((x) => LocationMember.fromJson(x))),
        mockData: List<MockData>.from(
            json["mockData"].map((x) => MockData.fromJson(x))),
      );
}

class LocationMember {
  final String fullname;
  final String image;
  final String type;
  final String message;
  final int isMember;
  final double lat;
  final double lng;

  LocationMember({required this.fullname, required this.image, required this.type, required this.message, required this.isMember, required this.lat, required this.lng});

  factory LocationMember.fromJson(Map<String, dynamic> json) => LocationMember(
    fullname: json['fullname'] ?? "", 
    image: json['image'] ?? "", 
    type: json['type'] ?? "", 
    message: json['message'] ?? "", 
    isMember: json['isMember'] ?? 1, 
    lat: json['lat'] ?? 0.toDouble(), 
    lng: json['lng']  ?? 0.toDouble());
}
class MockData {
  final String fullname;
  final String image;
  final String type;
  final String message;
  final int isMember;
  final double lat;
  final double lng;

  MockData({required this.fullname, required this.image, required this.type, required this.message, required this.isMember, required this.lat, required this.lng});

  factory MockData.fromJson(Map<String, dynamic> json) => MockData(
    fullname: json['fullname'] ?? "", 
    image: json['image'] ?? "", 
    type: json['type'] ?? "", 
    message: json['message'] ?? "", 
    isMember: json['isMember'] ?? 1, 
    lat: json['lat'] ?? 0.toDouble(), 
    lng: json['lng']  ?? 0.toDouble());
}

class LeaderDetail {
  final String fullname;
  final String image;
  final int isLeader;
  final double lat;
  final double lng;

  LeaderDetail({required this.fullname, required this.image, required this.isLeader, required this.lat, required this.lng});
  factory LeaderDetail.fromJson(Map<String, dynamic> json) => LeaderDetail(
      fullname: json['fullname'] ?? "",
      image: json['image'] ?? "",
      isLeader: json['isLeader'] ?? 1,
      lat: json['lat'] ?? 0.toDouble(),
      lng: json['lng'] ?? 0.toDouble());
}

final tripService = TripServices();
