import 'package:flutter/material.dart';
import 'package:foodeasecakes/config/application.dart';
import 'package:foodeasecakes/config/constants.dart';
import 'package:foodeasecakes/const/api_path.dart';
import 'package:foodeasecakes/models/addons_model.dart';
import 'package:foodeasecakes/models/cakes_model.dart';

abstract class CartRepository {
  List<CakeData> get cartItems => [];
  set cartItems(List<CakeData> data);

  Future<dynamic> getCartInfo();

  Future<dynamic> createCart(
      String name,
      String phoneNumber,
      bool paid,
      Variants selectedVariants,
      List<dynamic> images,
      String title,
      String? flavour,
      String messageOnCake,
      AddonsModel? addonsModel,
      DateTime dateTime);

  Future<dynamic> deleteCart(String id);
}

class CartRepositoryImpl extends CartRepository {
  List<CakeData> _cart = [];

  @override
  List<CakeData> get cartItems => [];

  @override
  set cartItems(List<CakeData> data) {
    _cart = data;
  }

  @override
  Future<dynamic> getCartInfo() async {
    try {
      var response = await Application.restService!.requestCall(
          apiEndPoint: "${ApiRestEndPoints.cart}",
          addAutherization: true,
          method: RestAPIRequestMethods.get);
      return response;
    } catch (exe) {
      return null;
    }
  }

  @override
  Future<dynamic> createCart(
      String name,
      String phoneNumber,
      bool paid,
      Variants selectedVariants,
      List<dynamic> images,
      String title,
      String? flavour,
      String messageOnCake,
      AddonsModel? addonsModel,
      DateTime dateTime) async {
    try {
      var response = await Application.restService!.requestCall(
          apiEndPoint: "${ApiRestEndPoints.cart}",
          requestParmas: {
            "name": name,
            "phoneNumber": phoneNumber,
            "paid": paid,
            "variants": selectedVariants,
            "flavour": flavour,
            "images": images,
            "title": title,
            "messageOnCake": messageOnCake,
            "addOns": addonsModel,
            "quantity": 1,
            "dateTime": dateTime.toString(),
          },
          addAutherization: true,
          method: RestAPIRequestMethods.post);
      return response;
    } catch (exe) {
      return null;
    }
  }

  @override
  Future<dynamic> deleteCart(String id) async {
    try {
      var response = await Application.restService!.requestCall(
          apiEndPoint: "${ApiRestEndPoints.cart}/${id}",
          addAutherization: true,
          method: RestAPIRequestMethods.delete);
      return response;
    } catch (exe) {
      return null;
    }
  }
}
