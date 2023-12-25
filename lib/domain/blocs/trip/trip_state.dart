part of 'trip_bloc.dart';

@immutable
class TripState {

  // final int privacyTrip;
  final List<File>? imageFileSelectedTrip;
  final bool isSearchFriend;

  const TripState({
    // this.privacyTrip = 1,
    this.imageFileSelectedTrip,
    this.isSearchFriend = false,
  });

  TripState copyWith({ List<File>? imageFileSelectedTrip, bool? isSearchFriend,})
    => TripState(
        // privacyTrip: privacyTrip ?? this.privacyTrip,
        imageFileSelectedTrip: imageFileSelectedTrip ?? this.imageFileSelectedTrip,
        isSearchFriend: isSearchFriend ?? this.isSearchFriend,
      );


}


class LoadingTrip extends TripState {}
class LoadingSaveTrip extends TripState {}

class FailureTrip extends TripState {
  final String error;

  const FailureTrip(this.error);
}

class SuccessTrip extends TripState {}

// class LoadingTrip extends TripState {}
// class SuccessTrip extends TripState {}
