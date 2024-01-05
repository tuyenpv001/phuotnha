import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:social_media/data/env/env.dart';
import 'package:social_media/data/storage/secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

part 'trip_chat_event.dart';
part 'trip_chat_state.dart';

class ChatTripBloc extends Bloc<ChatTripEvent, ChatTripState> {
  late io.Socket _socket;

  ChatTripBloc() : super(const ChatTripInitial()) {
    on<OnIsWrittingTripEvent>(_isWritting);
    on<OnEmitMessageTripEvent>(_emitMessages);
    on<OnListenMessageTripEvent>(_listenMessageEvent);
  }

  void initSocketChat() async {
    final token = await secureStorage.readToken();

    _socket = io.io(Environment.baseUrl + 'socket-chat-message', {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {'xxx-token': token}
    });

    _socket.connect();

    _socket.on('message-trip', (data) {
      print(data);
      add(OnListenMessageTripEvent(data['from'], data['to'], data['message']));
    });
  }

  void disconnectSocketMessagePersonal() {
    _socket.off('message-trip');
  }

  void disconnectSocket() {
    _socket.disconnect();
  }

  Future<void> _isWritting(
      OnIsWrittingTripEvent event, Emitter<ChatTripState> emit) async {
    emit(ChatSetIsWrittingTripState(writting: event.isWritting));
  }

  Future<void> _emitMessages(
      OnEmitMessageTripEvent event, Emitter<ChatTripState> emit) async {
    _socket.emit('message-trip', {
      'from': event.uidSource,
      'to': event.uidUserTarget,
      'message': event.message
    });
  }

  Future<void> _listenMessageEvent(
      OnListenMessageTripEvent event, Emitter<ChatTripState> emit) async {
    emit(ChatListengMessageTripState(
        uidFrom: event.uidFrom, uidTo: event.uidTo, messages: event.messages));
  }
}
