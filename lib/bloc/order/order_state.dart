part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();
}

class OrderInitial extends OrderState {
  @override
  List<Object> get props => [];
}

class OrderLoader extends OrderState {
  @override
  List<Object> get props => [];
}

class OrderDataLoaded extends OrderState {
  List<OrderData>? orderList;
  String? error;

  OrderDataLoaded({this.orderList, this.error});

  @override
  List<Object?> get props => [orderList, error];
}
