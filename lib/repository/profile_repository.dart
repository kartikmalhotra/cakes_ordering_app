import 'package:flutter/material.dart';
import 'package:foodeasecakes/config/application.dart';
import 'package:foodeasecakes/config/routes/routes_const.dart';
import 'package:foodeasecakes/const/api_path.dart';
import 'package:foodeasecakes/config/constants.dart';
import 'package:foodeasecakes/main.dart';

abstract class ProfileRepository {
  Future<dynamic> getUserProfile();
}

class ProfileRepositoryImpl extends ProfileRepository {
  @override
  Future<dynamic> getUserProfile() async {
    try {
      final response = await Application.restService!.requestCall(
          apiEndPoint: ApiRestEndPoints.userProfile,
          method: RestAPIRequestMethods.get,
          addAutherization: true);
      return response;
    } catch (exe) {
      return null;
    }
  }
}
