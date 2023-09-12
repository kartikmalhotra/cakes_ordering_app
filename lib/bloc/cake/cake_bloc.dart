import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foodeasecakes/const/app_constants.dart';
import 'package:foodeasecakes/main.dart';
import 'package:foodeasecakes/models/cakes_model.dart';
import 'package:foodeasecakes/repository/cakes_repository.dart';
import 'package:meta/meta.dart';

part 'cake_event.dart';
part 'cake_state.dart';

class CakeBloc extends Bloc<CakeEvent, CakeState> {
  final CakeRepositoryImpl repository;

  CakeBloc({required this.repository}) : super(CakeInitial()) {
    on<GetCakesEvent>((event, emit) => _mapGetCakeEventToState(event, emit));
    on<DeleteCakesEvent>(
        (event, emit) => _mapDeleteCakesEventToState(event, emit));
    on<CreateEditCakesEvent>(
        (event, emit) => _mapCreateCakesEventToState(event, emit));
  }

  Future<void> _mapGetCakeEventToState(GetCakesEvent event, emit) async {
    emit(CakeLoader());
    final response = await repository.getCakes(cakeType: event.cakeType);
    if (response is List) {
      final CakesDataModel _cakesDataModel =
          CakesDataModel.fromJson({"cakes_data": response});
      emit(CakesLoadedState(cakesDataModel: _cakesDataModel));
    } else {
      emit(CakesLoadedState(
        errorResult: response?['error'] ?? "Somthing went wrong",
      ));
    }
  }

  Future<void> _mapDeleteCakesEventToState(DeleteCakesEvent event, emit) async {
    emit(CakeLoader());
    final response = await repository.deleteCake(event.id);
    add(GetCakesEvent(dateTime: DateTime.now(), cakeType: event.cakeType));
  }

  Future<void> _mapCreateCakesEventToState(
      CreateEditCakesEvent event, emit) async {
    emit(CakeLoader());
    var response;
    if (!event.isEdit) {
      response = await repository.createCake(event.title, event.description,
          event.variants, event.flavours, event.image, event.cakeType);
    } else {
      response = await repository.editCake(
          event.id!,
          event.title,
          event.description,
          event.variants,
          event.flavours,
          event.image,
          event.cakeType);
    }
    if (response is Map && response["error"] == null) {
      Navigator.pop(App.globalContext);
      add(GetCakesEvent(dateTime: DateTime.now(), cakeType: null));
    } else {
      emit(CakesLoadedState(
        errorResult: response?['error'] ?? "Somthing went wrong",
      ));
    }
  }
}
