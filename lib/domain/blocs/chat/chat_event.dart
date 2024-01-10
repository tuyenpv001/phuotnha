part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class OnIsWrittingEvent extends ChatEvent {
  final bool isWritting;

  OnIsWrittingEvent(this.isWritting);
}

class OnEmitMessageEvent extends ChatEvent {
  final String uidSource;
  final String uidUserTarget;
  final String message;

  OnEmitMessageEvent(this.uidSource, this.uidUserTarget, this.message);
}

class OnListenMessageEvent extends ChatEvent {
  final String uidFrom;
  final String uidTo;
  final String messages;

  OnListenMessageEvent(this.uidFrom, this.uidTo, this.messages);

}

class OnEmitCallingListeningEvent extends ChatEvent {
  final bool isCalling;
  final Caller caller;
  final Caller receiver;
  final Channel channel;
  OnEmitCallingListeningEvent(this.isCalling,this.caller, this.receiver,this.channel);
}
class OnEmitMakeCallingListeningEvent extends ChatEvent {
  final bool isCalling;
  final Caller caller;
  final Caller receiver;
  final Channel channel;
  OnEmitMakeCallingListeningEvent(this.isCalling,this.caller, this.receiver,this.channel);
}
class OnCallListeningEvent extends ChatEvent {
  final bool isCalling;
  final Caller caller;
  final Caller receiver;
  final Channel channel;
  OnCallListeningEvent(this.isCalling,this.caller, this.receiver,this.channel);
}

class OnAcceptVideoCallEvent extends ChatEvent {
  final bool isVideoCalling;

  OnAcceptVideoCallEvent(this.isVideoCalling);
  
}



