part of 'cart_bloc.dart';

abstract class CartEvent {
  const CartEvent();
}

class AddToCartEvent extends CartEvent {
  final String name;
  final String phoneNumber;
  final String? selectedFlavour;
  final Variants selecteVariant;
  final String? messageOnCake;
  final AddonsModel? selectedAddOn;
  final DateTime? dateTime;
  final bool paid;
  final String? title;
  final List<dynamic> images;

  AddToCartEvent({
    required this.name,
    required this.phoneNumber,
    required this.selectedFlavour,
    required this.selecteVariant,
    required this.messageOnCake,
    required this.selectedAddOn,
    required this.dateTime,
    required this.paid,
    required this.title,
    required this.images,
  });
  @override
  List<Object?> get props => [
        selectedFlavour,
        selecteVariant,
        messageOnCake,
        selectedAddOn,
        dateTime,
        title,
        images,
      ];
}

class GetCartEvent extends CartEvent {
  final DateTime dateTime;
  const GetCartEvent({required this.dateTime});
  @override
  List<Object?> get props => [dateTime];
}

class DeleteCartEvent extends CartEvent {
  final String id;
  final DateTime dateTime;

  const DeleteCartEvent({required this.id, required this.dateTime});

  @override
  List<Object?> get props => [id, dateTime];
}
