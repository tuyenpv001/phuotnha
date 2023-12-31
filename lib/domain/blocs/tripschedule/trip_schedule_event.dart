part of 'trip_schedule_bloc.dart';

@immutable
abstract class TripScheduleEvent {}

class OnStartTrip extends TripScheduleEvent {
  final String tripId;
  OnStartTrip(this.tripId);
}

class OnRateTrip extends TripScheduleEvent {
  final String comment;
  final double rate;
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