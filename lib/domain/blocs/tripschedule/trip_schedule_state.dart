part of 'trip_schedule_bloc.dart';

@immutable
class TripScheduleState {
  // final int privacyTrip;
  // final List<File>? imageFileSelectedTrip;
  final String? tripId;

  const TripScheduleState({
    this.tripId
  });

  TripScheduleState copyWith({
    String? tripId,
  }) =>
      TripScheduleState(
        // privacyTrip: privacyTrip ?? this.privacyTrip,
        tripId: tripId ?? this.tripId
      );
}

class LoadingTripSchedule extends TripScheduleState {}

class LoadingSaveTripSchedule extends TripScheduleState {}
class LoadingAddRoleTripSchedule extends TripScheduleState {}

class FailureTripSchedule extends TripScheduleState {
  final String error;

  const FailureTripSchedule(this.error);
}

class SuccessTripSchedule extends TripScheduleState {}

// class LoadingTrip extends TripState {}
// class SuccessTrip extends TripState {}
