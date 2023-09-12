part of 'cake_form_bloc.dart';

abstract class CakeFormState extends Equatable {
  const CakeFormState();
}

class CakeFormInitial extends CakeFormState {
  @override
  List<Object> get props => [];
}

class UploadingMediaLoaderState extends CakeFormState {
  const UploadingMediaLoaderState();

  @override
  List<Object> get props => [];
}

class UploadingMediaFile extends CakeFormState {
  const UploadingMediaFile();

  @override
  List<Object> get props => [];
}

class UploadMediaUrlState extends CakeFormState {
  final String? url;
  final String? localUrl;
  final DateTime dateTime;
  final List<dynamic> images;

  const UploadMediaUrlState({
    this.url,
    this.localUrl,
    required this.dateTime,
    required this.images,
  });

  @override
  List<Object?> get props => [
        url,
        dateTime,
        images,
      ];
}

class StopMediaLoaderState extends CakeFormState {
  final DateTime dateTime;

  const StopMediaLoaderState({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}
