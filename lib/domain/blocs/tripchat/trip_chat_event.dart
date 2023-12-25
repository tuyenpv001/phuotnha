part of 'trip_chat_bloc.dart';

@immutable
abstract class ChatTripEvent {}

class OnIsWrittingTripEvent extends ChatTripEvent {
  final bool isWritting;

  OnIsWrittingTripEvent(this.isWritting);
}

class OnEmitMessageTripEvent extends ChatTripEvent {
  final String uidSource;
  final String uidUserTarget;
  final String message;

  OnEmitMessageTripEvent(this.uidSource, this.uidUserTarget, this.message);
}

class OnListenMessageTripEvent extends ChatTripEvent {
  final String uidFrom;
  final String uidTo;
  final String messages;

  OnListenMessageTripEvent(this.uidFrom, this.uidTo, this.messages);
}
