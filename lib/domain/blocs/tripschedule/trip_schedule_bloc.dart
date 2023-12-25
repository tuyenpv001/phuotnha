import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:social_media/domain/services/trip_services.dart';
part 'trip_schedule_event.dart';
part 'trip_schedule_state.dart';


class TripScheduleBloc extends Bloc<TripScheduleEvent, TripScheduleState> {

  TripScheduleBloc() : super(const TripScheduleState()) {
    on<OnStartTrip>(_onStartTrip);
    on<OnAddRoleTrip>(_addRoleTripByUser);
    on<OnRateTrip>(_rateTrip);
  }

  Future<void> _onStartTrip(OnStartTrip event, Emitter<TripScheduleState> emit) async {
        print(event.tripId);
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

}


