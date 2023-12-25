import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:social_media/domain/services/trip_services.dart';
part 'trip_event.dart';
part 'trip_state.dart';

class TripBloc extends Bloc<TripEvent, TripState> {

  List<File> listImages = [];

  TripBloc() : super(const TripState()) {

    // on<OnPrivacyTripEvent>(_onPrivacyTrip);
    on<OnSelectedImageEventTrip>(_onSelectedImage);
    on<OnClearSelectedImageEventTrip>(_onClearSelectedImage);
    on<OnAddNewTripEvent>(_addNewTrip);
    on<OnSaveTripByUser>(_saveTripByUser);
    on<OnJoinTrip>(_joinTrip);
    on<OnIsSearchTripEvent>(_isSearchTrip);
    on<OnLikeOrUnLikeTrip>(_likeOrUnlikeTrip);
    on<OnAddNewCommentEvent>(_addNewComment);
    on<OnLikeOrUnlikeComment>(_likeOrUnlikeComment);

  }

  // Future<void> _onPrivacyTrip( OnPrivacyTripEvent event, Emitter<TripState> emit ) async {
  //
  //   emit( state.copyWith( privacyTrip: event.privacyTrip ) );
  //
  // }


  Future<void> _onSelectedImage( OnSelectedImageEventTrip event, Emitter<TripState> emit ) async {

    listImages.add( event.imageSelected );

    emit( state.copyWith(imageFileSelectedTrip: listImages));

  }


  Future<void> _onClearSelectedImage( OnClearSelectedImageEventTrip event, Emitter<TripState> emit ) async {

    listImages.removeAt(event.indexImage);

    emit( state.copyWith(imageFileSelectedTrip: listImages));

  }


  Future<void> _addNewTrip( OnAddNewTripEvent event, Emitter<TripState> emit ) async {
    try {
      emit( LoadingTrip() );

      final data = await tripService.addNewTrip(event.tripTitle, event.tripDescription,event.tripFrom, event.tripTo,event.tripDateStart, event.tripDateEnd,event.tripMember,event.tripStatus, listImages);
      await Future.delayed(const Duration(milliseconds: 350));

      if( data.resp ){

        emit( SuccessTrip() );
        listImages.clear();
        emit(state.copyWith( imageFileSelectedTrip: listImages ));
        
      }else{

        emit( FailureTrip(data.message) );
      }
      
    } catch (e) {
      emit(FailureTrip(e.toString()));
    }

  }


  Future<void> _saveTripByUser( OnSaveTripByUser event, Emitter<TripState> emit ) async {

    try {

      emit(LoadingSaveTrip());

      final data = await tripService.saveTripByUser(event.idTrip);

      if( data.resp ){
        emit(SuccessTrip());
      }else{
        emit(FailureTrip(data.message));
      }
      
    } catch (e) {
      emit(FailureTrip(e.toString()));
    }

  }
  Future<void> _joinTrip( OnJoinTrip event, Emitter<TripState> emit ) async {

    try {

      emit(LoadingSaveTrip());

      final data = await tripService.joinTripByUser(event.tripId, event.type);

      if( data.resp ){
        emit(SuccessTrip());
      }else{
        emit(FailureTrip(data.message));
      }
      
    } catch (e) {
      emit(FailureTrip(e.toString()));
    }

  }


  Future<void> _isSearchTrip( OnIsSearchTripEvent event, Emitter<TripState> emit ) async {

     emit( state.copyWith(isSearchFriend: event.isSearchFriend));

   }


  Future<void> _likeOrUnlikeTrip( OnLikeOrUnLikeTrip event , Emitter<TripState> emit ) async {

    try {

      emit(LoadingTrip());

      final data = await tripService.likeOrUnlikeTrip(event.uidTrip, event.uidPerson);

      if( data.resp ){
        emit(SuccessTrip());
      }else{
        emit(FailureTrip(data.message));
      }
      
    } catch (e) {
      emit(FailureTrip(e.toString()));
    }

  }


  Future<void> _addNewComment( OnAddNewCommentEvent event , Emitter<TripState> emit ) async {

    try {

      emit(LoadingTrip());

      final data = await tripService.addNewComment(event.uidTrip, event.comment);

      if(data.resp){
        emit(SuccessTrip());
      }else{
        emit(FailureTrip(data.message));
      }
      
    } catch (e) {
      emit(FailureTrip(e.toString()));
    }

  }


  Future<void> _likeOrUnlikeComment( OnLikeOrUnlikeComment event , Emitter<TripState> emit ) async {

    try {

      emit(LoadingTrip());

      final data = await tripService.likeOrUnlikeComment(event.uidComment);

      if(data.resp){
        emit(SuccessTrip());
      }else{
        emit(FailureTrip(data.message));
      }
      
    } catch (e) {
      emit(FailureTrip(e.toString()));
    }

  }

}
