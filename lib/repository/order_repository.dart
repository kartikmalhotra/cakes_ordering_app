import 'package:flutter/material.dart';
import 'package:foodeasecakes/config/application.dart';
import 'package:foodeasecakes/config/constants.dart';
import 'package:foodeasecakes/const/api_path.dart';
import 'package:foodeasecakes/models/addons_model.dart';
import 'package:foodeasecakes/models/cakes_model.dart';
import 'package:foodeasecakes/models/cart_models.dart';

abstract class OrderRepository {
  // List<OrderData> get orderItems => [];
  // set orderItems(List<OrderData> data);

  Future<dynamic> getOrder();

  Future<dynamic> createOrder(List<CartData> cartItems);

  Future<dynamic> deleteOrder(String id);
}

class OrderRepositoryImpl extends OrderRepository {
  // List<OrderData> _cart = [];

  // @override
  // List<OrderData> get orderItems => [];

  // @override
  // set orderItems(List<OrderData> data) {
  //   _cart = data;
  // }

  @override
  Future<dynamic> getOrder() async {
    try {
      var response = await Application.restService!.requestCall(
          apiEndPoint: "${ApiRestEndPoints.order}",
          addAutherization: true,
          method: RestAPIRequestMethods.get);
      return response;
    } catch (exe) {
      return null;
    }
  }

  @override
  Future<dynamic> createOrder(List<CartData> cartItems) async {
    try {
      var response = await Application.restService!.requestCall(
          apiEndPoint: "${ApiRestEndPoints.order}",
          requestParmas: {"orderItems": cartItems},
          addAutherization: true,
          method: RestAPIRequestMethods.post);
      return response;
    } catch (exe) {
      return null;
    }
  }

  @override
  Future<dynamic> deleteOrder(String id) async {
    try {
      var response = await Application.restService!.requestCall(
          apiEndPoint: "${ApiRestEndPoints.order}/${id}",
          addAutherization: true,
          method: RestAPIRequestMethods.delete);
      return response;
    } catch (exe) {
      return null;
    }
  }
}
