import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:social_media/data/env/env.dart';
import 'package:social_media/data/storage/secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

part 'call_event.dart';
part 'call_state.dart';


class CallBloc extends Bloc<CallEvent, CallState> {

  late io.Socket _socket;

  CallBloc() : super(CallInitState()) {

    // on<OnIsWrittingEvent>( _isWritting );
    on<OnEmitCallingEvent>( _emitCalling );
    on<OnCallVideoRTCEvent>( _callingVideoRTC );
    on<OnCallVideoRTCStateEvent>( _callingVideoStateRTC );
    on<OnCancelVideoCallEvent>(_cancelVideoCall); 
    on<OnResetCallEvent>(_onResetCall);
    // on<OnListenMessageEvent>( _listenMessageEvent );

  }
  
  void initSocketChat() async {
    print("CÓ CHẠY KO");
    final token = await secureStorage.readToken();

    _socket = io.io(Environment.baseUrl + 'socket-chat-message', {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {
        'xxx-token': token
      }
    });

    _socket.connect();
    _socket.on('accept-calling', (data){
       print("=======================================ON data" + data['sessionOffer']);
       print("=======================================ON data" + data['callerId']);
       print("=======================================ON data" + data['receiveId']);
       print("=======================================ON data" + data['isOffer'].toString());
      add(OnCallVideoRTCStateEvent(data['sessionOffer'], data['sessionAnswer'], data['candidate'],data['callerId'], data['receiveId'], data['isOffer']));
    });

    
    _socket.emit('call-video-rtc', {
        'test': 'test'
    });

  }

  void disconnectSocketVideoCallPersonal(){
    _socket.off('call-video-rtc');
  }


  void disconnectSocket(){
    _socket.disconnect();
  }



  Future<void> _emitCalling( OnEmitCallingEvent event, Emitter<CallState> emit ) async {

    _socket.emit('call-video-rtc', {
    
    });

  }
  Future<void> _callingVideoRTC( OnCallVideoRTCEvent event, Emitter<CallState> emit ) async {

    _socket.emit('call-video-rtc', {
        'sessionOffer': event.strOffer,
        'sessionAnswer': event.strAnswer,
        'candidate': event.candidateTemp,
        'callerId': event.callId,
        'receiveId': event.receiId,
        'isOffer': event.offer
    });

  }
  Future<void> _callingVideoStateRTC( OnCallVideoRTCStateEvent event, Emitter<CallState> emit ) async {

      emit(CallVideoRTCState(
        isCannel: true,
      strOffer: event.strOffer, 
      strAnswer: event.strAnswer, 
      candidateTemp: event.candidateTemp, 
      callId: event.callId, 
      receiId: event.receiId, 
      offer: event.offer));
  }
  Future<void> _cancelVideoCall( OnCancelVideoCallEvent event, Emitter<CallState> emit ) async {

      emit(CancelCallVideoState(isCancel: event.cancel));
  }
  Future<void> _onResetCall( OnResetCallEvent event, Emitter<CallState> emit ) async {

       emit(const CallVideoRTCState(
          callId: '',
          candidateTemp: '',
          isCannel: false,
          offer: false,
          receiId: '',
          strAnswer: '',
          strOffer: '',
       ));
  }


}
