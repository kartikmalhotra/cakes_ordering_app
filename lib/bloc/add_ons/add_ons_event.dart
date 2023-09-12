part of 'add_ons_bloc.dart';

@immutable
abstract class AddOnsEvent extends Equatable {
  const AddOnsEvent();
}

class GetAddOnsEvent extends AddOnsEvent {
  final DateTime dateTime;

  GetAddOnsEvent({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}

class DeleteAddonsEvent extends AddOnsEvent {
  final String id;
  final DateTime dateTime;

  const DeleteAddonsEvent({required this.id, required this.dateTime});

  @override
  List<Object> get props => [id, dateTime];
}

class UploadMediaEvent extends AddOnsEvent {
  final File file;
  final DateTime dateTime;
  final List<dynamic> images;

  const UploadMediaEvent({
    required this.file,
    required this.dateTime,
    required this.images,
  });

  @override
  List<Object?> get props => [file, dateTime, images];
}

class CreateEditAddonsEvent extends AddOnsEvent {
  final String? id;
  final DateTime dateTime;
  final List<dynamic> images;
  final String name;
  final String price;
  final bool isEdit;

  const CreateEditAddonsEvent({
    this.id,
    required this.dateTime,
    required this.images,
    required this.name,
    required this.price,
    this.isEdit = false,
  });

  @override
  List<Object?> get props => [id, dateTime, images, name, price, isEdit];
}
