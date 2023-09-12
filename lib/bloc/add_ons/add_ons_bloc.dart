import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foodeasecakes/bloc/cake/cake_bloc.dart';
import 'package:foodeasecakes/main.dart';
import 'package:foodeasecakes/models/addons_model.dart';
import 'package:foodeasecakes/models/cakes_model.dart';
import 'package:foodeasecakes/repository/add_ons_reposittory.dart';
import 'package:foodeasecakes/utils/utils.dart';
import 'package:meta/meta.dart';

part 'add_ons_event.dart';
part 'add_ons_state.dart';

class AddOnsBloc extends Bloc<AddOnsEvent, AddOnsState> {
  final AddonsRepository repository;

  AddOnsBloc({required this.repository}) : super(AddOnsInitial()) {
    on<GetAddOnsEvent>((event, emit) => _mapGetAddonsEventToState(event, emit));
    on<DeleteAddonsEvent>(
        (event, emit) => _mapDeleteAddonsEventToState(event, emit));
    on<UploadMediaEvent>(
        (event, emit) => _mapUploadMediaEventToState(event, emit));
    on<CreateEditAddonsEvent>(
        (event, emit) => _mapCreateEditAddonsEventToState(event, emit));
  }

  Future<void> _mapGetAddonsEventToState(AddOnsEvent event, emit) async {
    emit(AddOnLoader());
    final response = await repository.getAddOns();
    if (response != null && response is List) {
      final AddOnsList _addOnsList =
          AddOnsList.fromJson({"addons_list": response});
      emit(AddOnsLoadedState(addOnsList: _addOnsList));
    } else {
      emit(AddOnsLoadedState(
        errorMessage: response?['error'] ?? "Somthing went wrong",
      ));
    }
  }

  Future<void> _mapDeleteAddonsEventToState(
      DeleteAddonsEvent event, emit) async {
    emit(AddOnLoader());
    final response = await repository.deleteAddons(event.id);
    add(GetAddOnsEvent(dateTime: DateTime.now()));
  }

  Future<void> _mapUploadMediaEventToState(UploadMediaEvent event, emit) async {
    emit(MediaUploadLoaderState());
    var response = await repository.uploadMedia(event.file);
    if (response != null) {
      List<dynamic> images = event.images;
      images.add({
        "id": images.length + 1,
        "url": response,
        "localUrl": event.file.path
      });
      emit(UploadMediaUrlState(dateTime: event.dateTime, images: images));
    } else {
      Utils.showFailureToast("Unable to upload a Media file");
    }
    emit(StopMediaUploadLoaderState(dateTime: DateTime.now()));
  }

  Future<void> _mapCreateEditAddonsEventToState(
      CreateEditAddonsEvent event, emit) async {
    emit(AddOnLoader());

    add(GetAddOnsEvent(dateTime: DateTime.now()));

    var response;
    if (!event.isEdit) {
      response = await await repository.createAddons(
          event.images, event.name, event.price);
    } else {
      response = await await repository.editAddons(
          event.id!, event.images, event.name, event.price);
    }
    if (response is Map && response["error"] == null) {
      Navigator.pop(App.globalContext);

      add(GetAddOnsEvent(dateTime: DateTime.now()));
    } else {
      Utils.showFailureToast("Something went wrong");
      emit(AddOnsLoadedState(
        errorMessage: response?['error'] ?? "Somthing went wrong",
      ));
    }
  }
}
