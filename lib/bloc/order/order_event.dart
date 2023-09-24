part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();
}

class GetOrderEvent extends OrderEvent {
  final DateTime? dateTime;
  const GetOrderEvent({this.dateTime});
  @override
  List<Object?> get props => [dateTime];
}

class DeleteOrderEvent extends OrderEvent {
  final String id;
  final DateTime dateTime;

  const DeleteOrderEvent({required this.id, required this.dateTime});

  @override
  List<Object> get props => [id, dateTime];
}

class AddOrderEvent extends OrderEvent {
  final List<CartData>? cartItems;
  final DateTime dateTime;

  const AddOrderEvent({required this.cartItems, required this.dateTime});

  @override
  List<Object?> get props => [cartItems, dateTime];
}
