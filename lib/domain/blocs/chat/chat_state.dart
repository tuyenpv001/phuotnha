part of 'chat_bloc.dart';

@immutable
abstract class ChatState {
  
  final bool isWritting;
  final bool isCalling;
  final bool isVideoCalling;

  final String? uidSource;
  final String? uidTarget;
  final String? message;
  final Channel? chanel;
  final Caller? caller;
  final Caller? receiver;


  const ChatState({
    this.isVideoCalling =  false,
    this.isCalling = false,
    this.isWritting = false,
    this.uidSource,
    this.uidTarget,
    this.message,
    this.caller,
    this.chanel,
    this.receiver
  });


}

class ChatInitial extends ChatState {
  const ChatInitial() : super(isWritting: false);
}

class ChatSetIsWrittingState extends ChatState {
  final bool writting;
  const ChatSetIsWrittingState({required this.writting}) : super(isWritting: writting);
}

class ChatListengMessageState extends ChatState {
  final String uidFrom;
  final String uidTo;
  final String messages;

  const ChatListengMessageState({
    required this.uidFrom, 
    required this.uidTo, 
    required this.messages
  }) : super ( uidSource: uidFrom, uidTarget: uidTo, message: messages);
}

class CallinglisteningState extends ChatState {
  final bool calling;
  final Channel chanelling;
  final Caller callering;
  final Caller receivering;

  const CallinglisteningState({required this.calling, required this.chanelling,required this.callering,required this.receivering}) : super(isCalling: calling, caller: callering, receiver: receivering,chanel: chanelling);
}
class MakeCallinglisteningState extends ChatState {
  final bool calling;
  final Channel chanelling;
  final Caller callering;
  final Caller receivering;

  const MakeCallinglisteningState({required this.calling, required this.chanelling,required this.callering,required this.receivering}) : super(isCalling: calling, caller: callering, receiver: receivering,chanel: chanelling);
}
class VideoCallingWhileAccept extends ChatState {
  final bool acceptVideo;

  const VideoCallingWhileAccept({required this.acceptVideo}) : super(isVideoCalling: acceptVideo);

}