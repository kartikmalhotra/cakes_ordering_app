part of 'cake_form_bloc.dart';

abstract class CakeFormEvent extends Equatable {
  const CakeFormEvent();
}

class UploadMediaUrlEvent extends CakeFormEvent {
  final File file;
  final DateTime dateTime;
  final List<dynamic> images;

  const UploadMediaUrlEvent({
    required this.file,
    required this.dateTime,
    required this.images,
  });

  @override
  List<Object?> get props => [file, dateTime, images];
}

class DeleteMediaUrlEvent extends CakeFormEvent {
  final List<Map<String, dynamic>> files;
  final DateTime dateTime;

  const DeleteMediaUrlEvent({required this.files, required this.dateTime});

  @override
  List<Object?> get props => [files, dateTime];
}
