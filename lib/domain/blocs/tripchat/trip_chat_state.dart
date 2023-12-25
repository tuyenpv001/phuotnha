part of 'trip_chat_bloc.dart';

@immutable
abstract class ChatTripState {
  final bool isWritting;

  final String? uidSource;
  final String? uidTarget;
  final String? message;

  const ChatTripState(
      {this.isWritting = false, this.uidSource, this.uidTarget, this.message});
}

class ChatTripInitial extends ChatTripState {
  const ChatTripInitial() : super(isWritting: false);
}

class ChatSetIsWrittingTripState extends ChatTripState {
  final bool writting;
  const ChatSetIsWrittingTripState({required this.writting})
      : super(isWritting: writting);
}

class ChatListengMessageTripState extends ChatTripState {
  final String uidFrom;
  final String uidTo;
  final String messages;

  const ChatListengMessageTripState(
      {required this.uidFrom, required this.uidTo, required this.messages})
      : super(uidSource: uidFrom, uidTarget: uidTo, message: messages);
}
