import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodeasecakes/config/application.dart';
import 'package:foodeasecakes/config/routes/routes_const.dart';
import 'package:foodeasecakes/const/api_path.dart';
import 'package:foodeasecakes/config/constants.dart';
import 'package:foodeasecakes/main.dart';

abstract class AddonsRepository {
  Future<dynamic> getAddOns();
  Future<dynamic> createAddons(
      final List<dynamic> images, final String name, final String price);
  Future<dynamic> editAddons(String id, final List<dynamic> images,
      final String name, final String price);
  Future<dynamic> deleteAddons(String id);
  Future<dynamic> uploadMedia(File file);
}

class AddonsRepositoryImpl extends AddonsRepository {
  @override
  Future<dynamic> getAddOns() async {
    try {
      var response = await Application.restService!.requestCall(
          apiEndPoint: ApiRestEndPoints.addOns,
          addAutherization: true,
          method: RestAPIRequestMethods.get);
      return response;
    } catch (exe) {
      return null;
    }
  }

  @override
  Future<dynamic> deleteAddons(String id) async {
    try {
      var response = await Application.restService!.requestCall(
          apiEndPoint: "${ApiRestEndPoints.addOns}/$id",
          addAutherization: true,
          addParams: {"id": id},
          method: RestAPIRequestMethods.delete);
      return response;
    } catch (exe) {
      return null;
    }
  }

  @override
  Future<dynamic> uploadMedia(File file) async {
    try {
      var response = await Application.restService!.uploadPhoto(file: file);
      if (kDebugMode) {
        print(response);
      }
      if (response != null) {
        return response;
      }
    } catch (exe) {
      return null;
    }

    // else if(mediaType == Meid)
  }

  @override
  Future<dynamic> createAddons(
      final List<dynamic> images, final String name, final String price) async {
    try {
      var response = await Application.restService!.requestCall(
          apiEndPoint: "${ApiRestEndPoints.addOns}",
          requestParmas: {
            "name": name,
            "price": price,
            "images": images,
          },
          addAutherization: true,
          method: RestAPIRequestMethods.post);
      return response;
    } catch (exe) {
      return null;
    }
  }

  @override
  Future<dynamic> editAddons(String id, final List<dynamic> images,
      final String name, final String price) async {
    try {
      var response = await Application.restService!.requestCall(
          apiEndPoint: "${ApiRestEndPoints.addOns}/$id",
          requestParmas: {
            "name": name,
            "price": price,
            "images": images,
          },
          addAutherization: true,
          method: RestAPIRequestMethods.put);
      return response;
    } catch (exe) {
      return null;
    }
  }
}
