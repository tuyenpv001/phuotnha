part of 'trip_schedule_bloc.dart';




@immutable
abstract class TripScheduleEvent {}

class OnStartTrip extends TripScheduleEvent {
  final String tripId;
  final String status;
  OnStartTrip(this.tripId, this.status);
}


class OnRateTrip extends TripScheduleEvent {
  final String comment;
  final String rate;
  final String tripUid;
  final String uid;

  OnRateTrip({required this.comment, required this.rate, required this.tripUid, required this.uid});
  
}

class OnAddRoleTrip extends TripScheduleEvent {
  final String uid;
  final String role;
  final String tripUid;

  OnAddRoleTrip({required this.uid, required this.role, required this.tripUid});
}
class OnUpdateLocationTrip extends TripScheduleEvent {
  final double lat;
  final double lng;


  OnUpdateLocationTrip({required this.lat, required this.lng,});
}

class OnUpdateLocationAllMemberTrip extends TripScheduleEvent {
  final String tripId;


  OnUpdateLocationAllMemberTrip({required this.tripId});
}


class OnUpdateLocationMembers extends TripScheduleEvent {
  final String tripId;

  OnUpdateLocationMembers({required this.tripId});

}