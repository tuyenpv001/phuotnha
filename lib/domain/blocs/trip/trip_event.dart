part of 'trip_bloc.dart';

@immutable
abstract class TripEvent {}

// class OnPrivacyTripEvent extends TripEvent {
//   // final int privacyTrip;
//
//   // OnPrivacyTripEvent(this.privacyTrip);
// }

class OnSelectedImageEventTrip extends TripEvent {
  final File imageSelected;

  OnSelectedImageEventTrip(this.imageSelected);
}

class OnClearSelectedImageEventTrip extends TripEvent {
  final int indexImage;

  OnClearSelectedImageEventTrip(this.indexImage);
}

class OnAddNewTripEvent extends TripEvent {
  final String tripTitle;
  final String tripDescription;
  final String tripFrom;
  final String tripTo;
  final String tripDateStart;
  final String tripDateEnd;
  final int tripMember;
  final String tripStatus;

  OnAddNewTripEvent(
      this.tripTitle,
      this.tripDescription,
      this.tripFrom,
      this.tripTo,
      this.tripDateStart,
      this.tripDateEnd,
      this.tripMember,
      this.tripStatus);
}

class OnSaveTripByUser extends TripEvent {
  final String idTrip;
  final String type;
  OnSaveTripByUser(this.idTrip, this.type);
}

class OnJoinTrip extends TripEvent {
  final String tripId;
  final String type;

  OnJoinTrip(this.tripId, this.type);
}

class OnIsSearchTripEvent extends TripEvent {
  final bool isSearchFriend;

  OnIsSearchTripEvent(this.isSearchFriend);
}

class OnNewStoryEvent extends TripEvent {}

class OnLikeOrUnLikeTrip extends TripEvent {
  final String uidTrip;
  final String uidPerson;

  OnLikeOrUnLikeTrip(this.uidTrip, this.uidPerson);
}

class OnAddNewCommentEvent extends TripEvent {
  final String uidTrip;
  final String comment;

  OnAddNewCommentEvent(this.uidTrip, this.comment);
}

class OnLikeOrUnlikeComment extends TripEvent {
  final String uidComment;

  OnLikeOrUnlikeComment(this.uidComment);
}


class OnDeleteTrip extends TripEvent {
  final String tripUid;

  OnDeleteTrip(this.tripUid);

}





