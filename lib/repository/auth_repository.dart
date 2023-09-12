import 'package:flutter/material.dart';
import 'package:foodeasecakes/config/application.dart';
import 'package:foodeasecakes/config/routes/routes_const.dart';
import 'package:foodeasecakes/const/api_path.dart';
import 'package:foodeasecakes/config/constants.dart';
import 'package:foodeasecakes/main.dart';

abstract class AuthRepository {
  Future<dynamic> login(String email, String password);
  Future<dynamic> forgetPassword(String email);
  Future<dynamic> logout();
  Future<dynamic> deleteAccount();
  Future<dynamic> signUp(
      String email, String password, String name, String phone);
}

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<dynamic> login(String email, String password) async {
    try {
      final response = await Application.restService!.requestCall(
          apiEndPoint: ApiRestEndPoints.login,
          method: RestAPIRequestMethods.post,
          requestParmas: {"email": email.toLowerCase(), "password": password});
      return response;
    } catch (exe) {
      return null;
    }
  }

  @override
  Future<dynamic> forgetPassword(String email) async {
    try {
      final response = await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.recoverPassword,
        method: RestAPIRequestMethods.post,
        requestParmas: {"email": email},
        addAutherization: true,
      );
      return response;
    } catch (exe) {
      return null;
    }
  }

  @override
  Future<dynamic> logout() async {
    try {
      final response = await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.logout,
        addAutherization: true,
        requestParmas: {},
        method: RestAPIRequestMethods.post,
      );
      return response;
    } catch (exe) {
      return null;
    }
  }

  @override
  Future<dynamic> deleteAccount() async {
    try {
      final response = await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.deleteAccount,
        addAutherization: true,
        requestParmas: {},
        method: RestAPIRequestMethods.delete,
      );
      return response;
    } catch (exe) {
      return null;
    }
  }

  @override
  Future<dynamic> signUp(
      String email, String password, String name, String phone) async {
    try {
      final response = await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.signup,
        requestParmas: {
          "email": email,
          "password": password,
          "name": name,
          "type": "user",
          "phone": phone,
        },
        method: RestAPIRequestMethods.post,
      );
      return response;
    } catch (exe) {
      return null;
    }
  }
}
