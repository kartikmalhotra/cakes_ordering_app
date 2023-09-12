part of 'add_ons_bloc.dart';

@immutable
abstract class AddOnsState {
  const AddOnsState();
}

class AddOnsInitial extends AddOnsState {
  @override
  List<Object> get props => [];
}

class AddOnLoader extends AddOnsState {
  @override
  List<Object> get props => [];
}

class MediaUploadLoaderState extends AddOnsState {
  const MediaUploadLoaderState();

  @override
  List<Object> get props => [];
}

class AddOnsLoadedState extends AddOnsState {
  final AddOnsList? addOnsList;
  final String? errorMessage;

  AddOnsLoadedState({
    this.addOnsList,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [addOnsList, errorMessage];
}

class StopMediaUploadLoaderState extends AddOnsState {
  final DateTime dateTime;
  const StopMediaUploadLoaderState({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}

class UploadingMediaFile extends AddOnsState {
  const UploadingMediaFile();

  @override
  List<Object> get props => [];
}

class UploadMediaUrlState extends AddOnsState {
  final DateTime dateTime;
  final List<dynamic> images;

  const UploadMediaUrlState({
    required this.dateTime,
    required this.images,
  });

  @override
  List<Object?> get props => [
        dateTime,
        images,
      ];
}
