import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foodeasecakes/config/constants.dart';
import 'package:foodeasecakes/repository/cake_form_repository.dart';
import 'package:foodeasecakes/utils/utils.dart';

part 'cake_form_event.dart';
part 'cake_form_state.dart';

class CakeFormBloc extends Bloc<CakeFormEvent, CakeFormState> {
  final CakesFormRepository repository;

  /// This flag is used to delete files which are uploaded
  bool mediaUploadedCached = false;

  CakeFormBloc({required this.repository}) : super(CakeFormInitial()) {
    on<UploadMediaUrlEvent>(
        (event, emit) => _mapUploadMediaUrlEventToState(event, emit));
    on<DeleteMediaUrlEvent>(
        (event, emit) => _mapDeleteMediaUrlEventToState(event, emit));
  }

  Future<void> _mapUploadMediaUrlEventToState(
      UploadMediaUrlEvent event, emit) async {
    emit(UploadingMediaLoaderState());
    var response = await repository.uploadMedia(event.file);
    if (response != null) {
      mediaUploadedCached = true;
      repository.addImageUrlData = response;
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
    emit(StopMediaLoaderState(dateTime: DateTime.now()));
  }

  Future<void> _mapDeleteMediaUrlEventToState(
      DeleteMediaUrlEvent event, emit) async {
    await repository.deleteMedia(event.files);
  }
}
