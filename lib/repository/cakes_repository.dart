import 'package:flutter/material.dart';
import 'package:foodeasecakes/config/application.dart';
import 'package:foodeasecakes/config/routes/routes_const.dart';
import 'package:foodeasecakes/const/api_path.dart';
import 'package:foodeasecakes/config/constants.dart';
import 'package:foodeasecakes/const/app_constants.dart';
import 'package:foodeasecakes/main.dart';
import 'package:foodeasecakes/models/cakes_model.dart';

abstract class CakeRepository {
  Future<dynamic> getCakes({String? cakeType});
  Future<dynamic> deleteCake(String id);
  Future<dynamic> createCake(
    String title,
    String description,
    List<Variants> variants,
    List<String> flavours,
    List<dynamic> image,
    String cakeType,
  );
  Future<dynamic> editCake(
    String id,
    String title,
    String description,
    List<Variants> variants,
    List<String> flavours,
    List<dynamic> image,
    String cakeType,
  );
}

class CakeRepositoryImpl extends CakeRepository {
  @override
  Future<dynamic> getCakes({String? cakeType}) async {
    try {
      Map<String, dynamic> params = {};

      if (cakeType != null) {
        params["cakeType"] = cakeType;
      }

      var response = await Application.restService!.requestCall(
          apiEndPoint: "${ApiRestEndPoints.cakes}",
          addParams: params,
          method: RestAPIRequestMethods.get);
      return response;
    } catch (exe) {
      return null;
    }
  }

  @override
  Future<dynamic> deleteCake(String id) async {
    try {
      var response = await Application.restService!.requestCall(
          apiEndPoint: "${ApiRestEndPoints.cakes}/$id",
          addAutherization: true,
          method: RestAPIRequestMethods.delete);
      return response;
    } catch (exe) {
      return null;
    }
  }

  @override
  Future<dynamic> createCake(
      String title,
      String description,
      List<Variants> variants,
      List<String> flavours,
      List<dynamic> image,
      String cakeType) async {
    try {
      var response = await Application.restService!.requestCall(
          apiEndPoint: "${ApiRestEndPoints.cakes}",
          requestParmas: {
            "title": title,
            "description": description,
            "variants": variants,
            "flavours": flavours,
            "images": image,
            "cakeType": cakeType
          },
          addAutherization: true,
          method: RestAPIRequestMethods.post);
      return response;
    } catch (exe) {
      return null;
    }
  }

  @override
  Future<dynamic> editCake(
      String id,
      String title,
      String description,
      List<Variants> variants,
      List<String> flavours,
      List<dynamic> image,
      String cakeType) async {
    try {
      var response = await Application.restService!.requestCall(
          apiEndPoint: "${ApiRestEndPoints.cakes}/$id",
          requestParmas: {
            "title": title,
            "description": description,
            "variants": variants,
            "flavours": flavours,
            "images": image,
            "cakeType": cakeType,
          },
          addAutherization: true,
          method: RestAPIRequestMethods.put);
      return response;
    } catch (exe) {
      return null;
    }
  }
}
