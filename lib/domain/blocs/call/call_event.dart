part of 'call_bloc.dart';

@immutable
abstract class CallEvent {}

class OnIsWrittingEvent extends CallEvent {
  final bool isWritting;

  OnIsWrittingEvent(this.isWritting);
}

class OnEmitCallingEvent extends CallEvent {
   final String callerUid;
  final String receiverUid;
  final String callerName;
  final String receiverName;
  final String callerAvatar;
  final String receiverAvatar;
  final bool isDisabled;

  OnEmitCallingEvent( this.callerUid,  this.receiverUid,  this.callerName,  this.receiverName,  this.callerAvatar,  this.receiverAvatar,  this.isDisabled);

}



class OnCallVideoRTCEvent extends CallEvent {
  final String strOffer;
  final String strAnswer;
  final String candidateTemp;
  final String callId;
  final String receiId;
  final bool offer;

  OnCallVideoRTCEvent(
     this.strOffer,
       this.strAnswer,
       this.candidateTemp,
       this.callId,
       this.receiId,
       this.offer) ;
}

class OnCallVideoRTCStateEvent extends CallEvent {
  final String strOffer;
  final String strAnswer;
  final String candidateTemp;
  final String callId;
  final String receiId;
  final bool offer;

  OnCallVideoRTCStateEvent(
     this.strOffer,
       this.strAnswer,
       this.candidateTemp,
       this.callId,
       this.receiId,
       this.offer) ;
}


// class OnListenMessageEvent extends ChatEvent {
//   final String uidFrom;
//   final String uidTo;
//   final String messages;

//   OnListenMessageEvent(this.uidFrom, this.uidTo, this.messages);

// }
class OnCancelVideoCallEvent extends CallEvent {
  final bool cancel;

  OnCancelVideoCallEvent(this.cancel);

}

class OnResetCallEvent extends CallEvent {

}



