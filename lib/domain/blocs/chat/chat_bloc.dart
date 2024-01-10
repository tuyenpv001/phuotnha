import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:social_media/data/env/env.dart';
import 'package:social_media/data/storage/secure_storage.dart';
import 'package:social_media/domain/blocs/user/user_bloc.dart';
import 'package:social_media/ui/screens/messages/videoCall/video_call_state.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

part 'chat_event.dart';
part 'chat_state.dart';


class ChatBloc extends Bloc<ChatEvent, ChatState> {

  late io.Socket _socket;

  ChatBloc() : super(const ChatInitial()) {

    on<OnIsWrittingEvent>( _isWritting );
    on<OnEmitMessageEvent>( _emitMessages );
    on<OnListenMessageEvent>( _listenMessageEvent );
    on<OnEmitCallingListeningEvent>(_callingListening);
    on<OnCallListeningEvent>(_listenCallEvent);
    on<OnEmitMakeCallingListeningEvent>(_makeCalling);
    on<OnAcceptVideoCallEvent>(_acceptVideoCalling);

  }
  
  void initSocketChat() async {

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

    _socket.on('message-personal', (data) {
        add( OnListenMessageEvent(data['from'], data['to'], data['message']) );
    });

    _socket.on('call-video', (data) {
      print("Chat bloc 48 $data");
      //  'isCalling': true,
      // 'callerId': event.caller.id,
      // 'callerName': event.caller.name,
      // 'callerAvatar': event.caller.avatar,
      // 'receiverId': event.receiver.id,
      // 'receiverName': event.receiver.name,
      // 'receiverAvatar': event.receiver.avatar,
      // 'channelId': event.channel.channelId,
      // 'channelName': event.channel.channelName,
      add(OnCallListeningEvent(data['isCalling'], 
      Caller(id: data['callerId'], name: data['callerName'], avatar: data['callerAvatar']), 
      Caller(id: data['receiverId'], name: data['receiverName'], avatar: data['receiverAvatar']), 
      Channel(channelId: data['channelId'], channelName: data['channelName'])));
      add(OnEmitMakeCallingListeningEvent(data['isCalling'], 
      Caller(id: data['callerId'], name: data['callerName'], avatar: data['callerAvatar']), 
      Caller(id: data['receiverId'], name: data['receiverName'], avatar: data['receiverAvatar']), 
      Channel(channelId: data['channelId'], channelName: data['channelName'])));
    });


    _socket.on('calling', (data) {
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $data");
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $data");
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $data");
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $data");
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $data");
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $data");
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $data");

      add(OnAcceptVideoCallEvent(true));

    });
  }

  void disconnectSocketMessagePersonal(){
    _socket.off('message-personal');
  }


  void disconnectSocket(){
    _socket.disconnect();
  }


  Future<void> _isWritting( OnIsWrittingEvent event, Emitter<ChatState> emit ) async {

    emit( ChatSetIsWrittingState(writting: event.isWritting) );

  }


  Future<void> _emitMessages( OnEmitMessageEvent event, Emitter<ChatState> emit ) async {

    _socket.emit('message-personal', {
      'from': event.uidSource,
      'to':  event.uidUserTarget,
      'message': event.message
    });

  }
  Future<void> _callingListening( OnEmitCallingListeningEvent event, Emitter<ChatState> emit ) async {
   
    _socket.emit('call-video',{
      'isCalling': true,
      'callerId': event.caller.id,
      'callerName': event.caller.name,
      'callerAvatar': event.caller.avatar,
      'receiverId': event.receiver.id,
      'receiverName': event.receiver.name,
      'receiverAvatar': event.receiver.avatar,
      'channelId': event.channel.channelId,
      'channelName': event.channel.channelName,
    });

  }
  Future<void> _makeCalling( OnEmitMakeCallingListeningEvent event, Emitter<ChatState> emit ) async {
     emit(MakeCallinglisteningState(calling: event.isCalling, 
      chanelling: event.channel, 
     callering: event.caller ,
     receivering: event.receiver));
  }


  Future<void> _listenMessageEvent( OnListenMessageEvent event, Emitter<ChatState> emit ) async {

    emit( ChatListengMessageState(uidFrom: event.uidFrom, uidTo: event.uidTo, messages: event.messages) );

  }
  Future<void> _listenCallEvent( OnCallListeningEvent event, Emitter<ChatState> emit ) async {

    emit( CallinglisteningState(calling: event.isCalling, callering: event.caller,receivering: event.receiver,chanelling: event.channel) );

  }
  Future<void> _acceptVideoCalling( OnAcceptVideoCallEvent event, Emitter<ChatState> emit ) async {

    emit(VideoCallingWhileAccept(acceptVideo: event.isVideoCalling) );

  }


}
