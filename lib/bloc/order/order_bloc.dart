import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foodeasecakes/main.dart';
import 'package:foodeasecakes/models/cart_models.dart';
import 'package:foodeasecakes/models/order_model.dart';
import 'package:foodeasecakes/repository/order_repository.dart';
import 'package:foodeasecakes/utils/utils.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepositoryImpl repository;

  OrderBloc({required this.repository}) : super(OrderInitial()) {
    on<GetOrderEvent>((event, emit) => _mapGetOrderEventToState(event, emit));
    on<DeleteOrderEvent>(
        (event, emit) => _mapDeleteOrderEventToState(event, emit));
    on<AddOrderEvent>((event, emit) => _mapAddOrderEventToState(event, emit));
  }

  Future<void> _mapGetOrderEventToState(GetOrderEvent event, emit) async {
    emit(OrderLoader());
    final response = await repository.getOrder();
    if (response is! Map) {
      final OrderDataModel orderDataModel =
          OrderDataModel.fromJson({"order_data": response});
      if (event.dateTime != null) {
        List<OrderData> orderList = orderDataModel.orderList ?? [];
        List<OrderData> filteredOrderList = [];
        for (int i = 0; i < orderList.length; i++) {
          String? stringDateTime = orderList[i].dateTime;
          if (stringDateTime != null) {
            DateTime dateTime = DateTime.parse(stringDateTime);
            if (dateTime.day == event.dateTime?.day &&
                dateTime.month == event.dateTime?.month &&
                dateTime.year == event.dateTime?.year) {
              filteredOrderList.add(orderList[i]);
            }
          }
        }
        emit(OrderDataLoaded(orderList: filteredOrderList));
      } else {
        emit(OrderDataLoaded(orderList: orderDataModel.orderList ?? []));
      }
    } else {
      emit(OrderDataLoaded(
          error: response["error"] ??
              "Something went wrong. Unable to load the cart"));
    }
  }

  Future<void> _mapDeleteOrderEventToState(DeleteOrderEvent event, emit) async {
    emit(OrderLoader());
    final response = await repository.deleteOrder(event.id);
    add(GetOrderEvent(dateTime: DateTime.now()));
  }

  Future<void> _mapAddOrderEventToState(AddOrderEvent event, emit) async {
    emit(OrderLoader());
    final response = await repository.createOrder(event.cartItems ?? []);
    print(response);
    if (response is! Map) {
      final OrderDataModel orderDataModel =
          OrderDataModel.fromJson({"order_data": response});

      emit(OrderDataLoaded(orderList: orderDataModel.orderList ?? []));
      Utils.showSuccessToast("Your order is successfully placed");
      Navigator.pop(App.globalContext);
    } else {
      emit(OrderDataLoaded(
          error: response["error"] ??
              "Something went wrong. Unable to load the cart"));
    }
  }
}
