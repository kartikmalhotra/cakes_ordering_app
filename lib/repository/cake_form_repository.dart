import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodeasecakes/config/application.dart';
import 'package:foodeasecakes/config/routes/routes_const.dart';
import 'package:foodeasecakes/const/api_path.dart';
import 'package:foodeasecakes/config/constants.dart';
import 'package:foodeasecakes/main.dart';
import 'package:http/http.dart' as http;

abstract class CakesFormRepository {
  List<String> get imagesURL => [];
  set imagesURLData(List<String> imageData);

  set addImageUrlData(String imageData);

  Future<dynamic> deleteMedia(List<Map<String, dynamic>> path);

  Future<dynamic> getCakes();
  Future<dynamic> deleteCakes(String id);
  Future<dynamic> uploadMedia(File file);
}

class CakesFormRepositoryImpl extends CakesFormRepository {
  List<String> _imageURL = [];

  @override
  List<String> get imagesURL => _imageURL;

  @override
  set imagesURLData(List<String> imageData) {
    _imageURL = imageData;
  }

  @override
  set addImageUrlData(String imageData) {
    _imageURL.add(imageData);
  }

  @override
  Future<dynamic> getCakes() async {
    try {
      var response = await Application.restService!.requestCall(
          apiEndPoint: ApiRestEndPoints.cakes,
          addAutherization: true,
          method: RestAPIRequestMethods.get);
      return response;
    } catch (exe) {
      return null;
    }
  }

  @override
  Future<dynamic> deleteCakes(String id) async {
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
  Future<dynamic> deleteMedia(List<Map<String, dynamic>> path) async {
    List<String> filesPath = [];

    for (int i = 0; i < path.length; i++) {
      if (path[i]["url"].isNotEmpty) {
        filesPath.add(path[i]["url"].split("/").last);
      }
    }

    try {
      print("Deleting files");
      print(filesPath);
      await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.deleteFiles,
        requestParmas: {"files": filesPath},
        method: RestAPIRequestMethods.post,
        addAutherization: true,
      );
    } catch (exe) {}
  }
}
