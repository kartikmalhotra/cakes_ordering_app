part of 'cake_bloc.dart';

@immutable
abstract class CakeEvent extends Equatable {
  const CakeEvent();
}

class GetCakesEvent extends CakeEvent {
  final DateTime dateTime;
  final String? cakeType;

  const GetCakesEvent({required this.dateTime, this.cakeType});

  @override
  List<Object?> get props => [dateTime, cakeType];
}

class DeleteCakesEvent extends CakeEvent {
  final String id;
  final DateTime dateTime;
  final String? cakeType;

  const DeleteCakesEvent({
    required this.id,
    required this.dateTime,
    this.cakeType,
  });

  @override
  List<Object?> get props => [id, dateTime, cakeType];
}

class CreateEditCakesEvent extends CakeEvent {
  final String? id;
  final String title;
  final String description;
  final List<Variants> variants;
  final List<String> flavours;
  final List<dynamic> image;
  final bool isEdit;
  final String cakeType;

  const CreateEditCakesEvent({
    this.id,
    required this.title,
    required this.description,
    required this.variants,
    required this.flavours,
    required this.image,
    this.isEdit = false,
    required this.cakeType,
  });

  @override
  List<Object?> get props => [
        title,
        description,
        variants,
        flavours,
        image,
        isEdit,
        cakeType,
      ];
}
