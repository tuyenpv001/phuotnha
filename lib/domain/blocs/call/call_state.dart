part of 'call_bloc.dart';

@immutable
abstract class CallState {
   final bool isDisabled;
  final String? sessionOffer;
  final String? sessionAnswer;
  final String? candidate;
  final String? callerId;
  final String? receiverId;
  final bool isOffer;
  const CallState(
      {this.isOffer = false,
        this.isDisabled = false,
      this.sessionOffer,
      this.sessionAnswer,
      this.candidate,
      this.callerId,
      this.receiverId});
}

class CallInitState extends CallState{
  // final bool isDisabled;
  // final String? sessionOffer;
  // final String? sessionAnswer;
  // final String? candidate;
  // final String? callerId;
  // final String? receiverId;

  // CallInitState({this.isDisabled = false,
  // this.sessionOffer,this.sessionAnswer,this.candidate,
  // this.callerId,this.receiverId
  // });
}

class CallSendingState extends CallState{
  final String? callerUid;
  final String? receiverUid;
  final String? callerName;
  final String? receiverName;
  final String? callerAvatar;
  final String? receiverAvatar;


   const CallSendingState({
    this.callerUid,
    this.receiverUid,
    this.callerName,
    this.receiverName,
    this.callerAvatar,
    this.receiverAvatar
  });


}

class CallVideoRTCState extends CallState {
  final bool isCannel;
  final String strOffer;
  final String strAnswer;
  final String candidateTemp;
  final String callId;
  final String receiId;
  final bool offer;

  const CallVideoRTCState({required this.strOffer, required this.strAnswer, required this.candidateTemp, required this.callId, required this.receiId, required this.offer, required this.isCannel}): super(callerId: callId,candidate: candidateTemp,receiverId: receiId,sessionAnswer: strAnswer,
  sessionOffer: strOffer,
  isOffer: offer,
  isDisabled: isCannel
  );
}


class CancelCallVideoState extends CallState {
  final bool isCancel;

  const CancelCallVideoState({ required this.isCancel}): super(isDisabled: isCancel);

}