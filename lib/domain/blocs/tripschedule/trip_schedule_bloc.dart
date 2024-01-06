import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:social_media/data/env/env.dart';
import 'package:social_media/data/storage/secure_storage.dart';
import 'package:social_media/domain/services/trip_services.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
part 'trip_schedule_event.dart';
part 'trip_schedule_state.dart';


class TripScheduleBloc extends Bloc<TripScheduleEvent, TripScheduleState> {
  late io.Socket _socket;
  TripScheduleBloc() : super(const TripScheduleState()) {
    on<OnStartTrip>(_onStartTrip);
    on<OnAddRoleTrip>(_addRoleTripByUser);
    on<OnRateTrip>(_rateTrip);
  }

  Future<void> _onStartTrip(OnStartTrip event, Emitter<TripScheduleState> emit) async {
    try {
   
        await tripService.changeStatusTrip(event.tripId, event.status);

    } catch (e) {
      emit(FailureTripSchedule(e.toString()));
    }
  }

  Future<void> _addRoleTripByUser(
    OnAddRoleTrip event, Emitter<TripScheduleState> emit) async {
    try {
      emit(LoadingAddRoleTripSchedule());

      final data = await tripService.addRoleTripByUser(event.uid, event.tripUid, event.role);

      if (data.resp) {
        emit(SuccessTripSchedule());
      } else {
        emit(FailureTripSchedule(data.message));
      }
    } catch (e) {
      emit(FailureTripSchedule(e.toString()));
    }
  }

  Future<void> _rateTrip(
    OnRateTrip event, Emitter<TripScheduleState> emit) async {
    try {
      emit(LoadingAddRoleTripSchedule());

      final data = await tripService.addCommentAndRateTripByUser(event.uid, event.tripUid, event.comment, event.rate);

      if (data.resp) {
        emit(SuccessTripSchedule());
      } else {
        emit(FailureTripSchedule(data.message));
      }
    } catch (e) {
      emit(FailureTripSchedule(e.toString()));
    }
  }


  //Add socket trip start
  void initSocketChat() async {
    try {
       final token = await secureStorage.readToken();

      _socket = io.io(Environment.baseUrl + 'socket-chat-message', {
        'transports': ['websocket'],
        'autoConnect': true,
        'forceNew': true,
        'extraHeaders': {'xxx-token': token}
      });

      _socket.connect();

      _socket.on('trip-start', (data) {
        print("Connect");
        // add(OnListenMessageEvent(data['from'], data['to'], data['message']));
      });
    } catch (e) {
      print(e);
    }
   
  }

  void disconnectSocketMessagePersonal() {
    _socket.off('trip-start');
  }

  void disconnectSocket() {
    _socket.disconnect();
  }


  // Future<void> _emitMessages(
  //     OnEmitMessageEvent event, Emitter<ChatState> emit) async {
  //   _socket.emit('message-personal', {
  //     'from': event.uidSource,
  //     'to': event.uidUserTarget,
  //     'message': event.message
  //   });
  // }

  // Future<void> _listenMessageEvent(
  //     OnListenMessageEvent event, Emitter<ChatState> emit) async {
  //   emit(ChatListengMessageState(
  //       uidFrom: event.uidFrom, uidTo: event.uidTo, messages: event.messages));
  // }






}


