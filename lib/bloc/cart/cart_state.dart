part of 'cart_bloc.dart';

@immutable
abstract class CartState extends Equatable {}

class CartInitial extends CartState {
  @override
  List<Object> get props => [];
}

class CartLoader extends CartState {
  @override
  List<Object> get props => [];
}

class CartDataLoaded extends CartState {
  List<CartData>? cartList;
  String? error;
  int totalAmount;

  CartDataLoaded({this.cartList, this.error, this.totalAmount = 0});

  @override
  List<Object?> get props => [cartList, error, totalAmount];
}
