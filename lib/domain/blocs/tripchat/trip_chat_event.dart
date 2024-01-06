part of 'trip_chat_bloc.dart';

@immutable
abstract class ChatTripEvent {}

class OnIsWrittingTripEvent extends ChatTripEvent {
  final bool isWritting;

  OnIsWrittingTripEvent(this.isWritting);
}

class OnEmitMessageTripEvent extends ChatTripEvent {
  final String userId;
  final String tripId;
  final String message;

  OnEmitMessageTripEvent(this.userId, this.tripId, this.message);
}

class OnListenMessageTripEvent extends ChatTripEvent {
  final String userId;
  final String tripId;
  final String messages;

  OnListenMessageTripEvent(this.userId, this.tripId, this.messages);
}
