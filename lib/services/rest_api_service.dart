import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http_parser/http_parser.dart' as parser;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodeasecakes/config/constants.dart';
import 'package:http/http.dart' as http;
import 'package:foodeasecakes/config/application.dart';
import 'package:foodeasecakes/config/routes/routes_const.dart';
import 'package:foodeasecakes/const/api_path.dart';
import 'package:foodeasecakes/main.dart';

class RestAPIService {
  static RestAPIService? _instance;
  static late String _apiBaseUrl;

  RestAPIService._internal();

  static RestAPIService? getInstance() {
    _instance ??= RestAPIService._internal();

    /// Production
    _apiBaseUrl = "";

    if (kDebugMode) {
      print(_apiBaseUrl);
    }

    return _instance;
  }

  /// Set the PNM API Base URL
  /// Called when setting syncing mobile app with other server
  set appAPIBaseUrlData(String data) {
    _apiBaseUrl = data;
  }

  String get appAPIBaseUrl => _apiBaseUrl;

  Future<String> uploadPhoto({required dynamic file}) async {
    print("API called uploadPhoto");
    try {
      final response = http.MultipartRequest(
          'POST', Uri.parse("$_apiBaseUrl${ApiRestEndPoints.uploadImage}"));
      response.files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: parser.MediaType.parse(
            'image/${file.path.substring(file.path.lastIndexOf('.') + 1)}'),
      ));
      response.headers.addAll({
        'Authorization': AppUser.authToken!,
        'Content-Type': 'multipart/form-data',
      });

      final _resp = await response.send();
      if (_resp.statusCode == 200) {
        return await _resp.stream.bytesToString();
      } else {
        return "";
      }
    } catch (error) {
      // _handleHttpError(method: 'POST', route: route, error: error);
      return '';
    }
  }

  Future<dynamic> requestCall(
      {required String? apiEndPoint,
      required RestAPIRequestMethods method,
      dynamic requestParmas,
      Map<String, dynamic>? addParams,
      bool isFileRequest = false,
      bool givenAPIUrl = false,
      bool addAutherization = false}) async {
    String? _apiEndPoint = apiEndPoint;

    Map<String, String> _httpHeaders = {
      HttpHeaders.contentTypeHeader: "application/json"
    };

    /// Check if [addParams] is not null and [_apiEndPoint] is having [:] then modify the apiEndpoint for [GET] request
    if (addParams != null && addParams.isNotEmpty) {
      _apiEndPoint = _modifyAPIEndPoint(_apiEndPoint, addParams);
    }

    /// Check whether to skip the authorization token in the requested [apiEndpoint]
    if (addAutherization) {
      if (AppUser.authToken == null) {
        return;
      }
      _httpHeaders[HttpHeaders.authorizationHeader] = AppUser.authToken!;
    }

    /// make the complete URL of API
    Uri? _apiUrl;

    if (!givenAPIUrl) {
      /// Make complete API URL
      _apiUrl = Uri.parse('$_apiBaseUrl$_apiEndPoint');
    } else {
      _apiUrl = Uri.parse('$_apiEndPoint');
    }

    print("************** API called point $_apiUrl *****************");

    /// json encode the request params
    dynamic _requestParmas = json.encode(requestParmas);

    /// check the device OS for appending in request header

    dynamic responseJson;

    switch (method) {
      case RestAPIRequestMethods.get:
        try {
          final response = await http.get(_apiUrl, headers: _httpHeaders);
          responseJson =
              _returnResponse(response, isFileRequest: isFileRequest);
        } on SocketException {
          responseJson = {
            "error":
                'No internet connection found, Please check your internet and try again!'
          };
        } on FormatException {
          responseJson = {
            "error":
                'Unable to process your request due to some failure, Please try again later!'
          };
        } on http.ClientException {
          responseJson = {
            "error":
                'Oh No! Unable to process your request. Possible cases may be server is not reachable or if server runs on VPN then VPN should be connected on mobile device!'
          };
        } catch (exe) {
          if (kDebugMode) {
            print(exe.toString());
          }
        }
        break;
      case RestAPIRequestMethods.post:
        try {
          final response = await http.post(_apiUrl,
              body: _requestParmas, headers: _httpHeaders);
          responseJson = _returnResponse(response);
        } on SocketException {
          responseJson = {
            "error":
                'No internet connection found, Please check your internet and try again!'
          };
        } on FormatException {
          responseJson = {
            "error":
                'Unable to process your request due to some failure, Please try again later!'
          };
        } on http.ClientException {
          responseJson = {
            "error":
                'Oh No! Unable to process your request. Possible cases may be server is not reachable or if server runs on VPN then VPN should be connected on mobile device!'
          };
        } catch (exe) {
          if (kDebugMode) {
            print(exe.toString());
          }
        }

        break;
      case RestAPIRequestMethods.put:
        try {
          final response = await http.put(_apiUrl,
              body: _requestParmas, headers: _httpHeaders);
          responseJson = _returnResponse(response);
        } on SocketException {
          responseJson = {
            "error":
                'No internet connection found, Please check your internet and try again!'
          };
        } on FormatException {
          responseJson = {
            "error":
                'Unable to process your request due to some failure, Please try again later!'
          };
        } on http.ClientException {
          responseJson = {
            "error":
                'Oh No! Unable to process your request. Possible cases may be server is not reachable or if server runs on VPN then VPN should be connected on mobile device!'
          };
        } catch (exe) {
          if (kDebugMode) {
            print(exe.toString());
          }
        }
        break;
      case RestAPIRequestMethods.delete:
        try {
          /// normal delete request without body
          if (requestParmas == null) {
            final response = await http.delete(_apiUrl, headers: _httpHeaders);
            responseJson = _returnResponse(response);
          } else {
            /// delete request with body
            final request = http.Request("DELETE", _apiUrl);
            request.headers.addAll(_httpHeaders);
            request.body = json.encode(requestParmas);
            final streamedResponse = await request.send();
            final response = await http.Response.fromStream(streamedResponse);
            responseJson = _returnResponse(response);
          }
        } on SocketException {
          responseJson = {
            "error":
                'Unable to process your request due to some failure, Please try again later!'
          };
        } on FormatException {
          responseJson = {
            "error":
                'Unable to process your request due to some failure, Please try again later!'
          };
        } on http.ClientException {
          responseJson = {
            "error":
                'Unable to process your request due to some failure, Please try again later!'
          };
        } catch (exe) {
          if (kDebugMode) {
            print(exe.toString());
          }
        }
        break;
      case RestAPIRequestMethods.patch:
        try {
          final response = await http.patch(_apiUrl,
              body: _requestParmas, headers: _httpHeaders);
          responseJson = _returnResponse(response);
        } on SocketException {
          responseJson = {
            "error":
                'Unable to process your request due to some failure, Please try again later!'
          };
        } on FormatException {
          responseJson = {
            "error":
                'Unable to process your request due to some failure, Please try again later!'
          };
        } on http.ClientException {
          responseJson = {
            "error":
                'Unable to process your request due to some failure, Please try again later!'
          };
        } catch (exe) {
          if (kDebugMode) {
            print(exe.toString());
          }
        }
        break;
      default:
        break;
    }
    return responseJson;
  }

  /// This function returns the apiEndPoints by modifying the Endpoint i.e by replacing the [:tmp] with actual content required for [GET] request
  static String? _modifyAPIEndPoint(
      String? apiEndPoint, Map<String, dynamic> addParams) {
    String? _modifiedAPIEndPoint = '$apiEndPoint?';
    String _requestParams = '';
    addParams.forEach((key, value) {
      _requestParams += "$key=${value.toString()}&";
    });
    _requestParams = _requestParams.substring(0, _requestParams.length - 1);
    return _modifiedAPIEndPoint + _requestParams;
  }

  // Future<String> uploadPhoto({required dynamic file}) async {
  //   print("API called uploadPhoto");
  //   try {
  //     final response =
  //         http.MultipartRequest('POST', Uri.parse('/upload/image'));
  //     response.files.add(await http.MultipartFile.fromPath(
  //       'file',
  //       file.path,
  //       contentType: parser.MediaType.parse(
  //           'image/${file.path.substring(file.path.lastIndexOf('.') + 1)}'),
  //     ));
  //     response.headers.addAll({
  //       'Authorization': LocalStorage().token,
  //       'Content-Type': 'multipart/form-data',
  //     });

  //     final _resp = await response.send();
  //     if (_resp.statusCode == 200) {
  //       return await _resp.stream.bytesToString();
  //     } else {
  //       return "";
  //     }
  //   } catch (error) {
  //     // _handleHttpError(method: 'POST', route: route, error: error);
  //     return '';
  //   }
  // }

  static Future<void> logoutUser() async {
    AppUser.email =
        AppUser.password = AppUser.firebaseToken = AppUser.authToken = null;
    AppUser.isLoggedIn = false;
    Application.localStorageService!.removeDataFromLocalStorage();
    await Application.secureStorageService!.deleteAllDataFromSecureStorage();
  }

  static dynamic _returnResponse(http.Response response,
      {bool isFileRequest = false}) async {
    if (response.reasonPhrase?.toLowerCase() == "conflict" &&
        ModalRoute.of(App.globalContext)?.settings.name != AppRoutes.login) {
      Navigator.pushNamedAndRemoveUntil(
          App.globalContext, AppRoutes.login, (route) => true);
      await logoutUser();

      return;
    }
    switch (response.statusCode) {
      case 200:
      case 304:
      case 201:
        var returnJson = jsonDecode(response.body);
        return returnJson;
      case 204:
        Map<String, bool> _returnMap = {'success': true};
        return _returnMap;
      case 400:
        if (response.body.isNotEmpty) {
          var returnJson = jsonDecode(response.body);
          if (returnJson.containsKey("message")) {
            return {
              'error': returnJson["message"],
              'score': returnJson["score"] ?? null,
              "error_detail": returnJson["errors"]
            };
          }
        }
        return {'error': response.reasonPhrase};
      case 401:
      // return RestAPIUnAuthenticationModel.fromJson(_responseBody['error']);
      case 403:
        if (response.body.isNotEmpty) {
          var returnJson = jsonDecode(response.body);
          if (returnJson.containsKey("message")) {
            return {'error': returnJson["message"]};
          }
        }
        return {'error': response.reasonPhrase};
      case 404:
        if (response.body.isNotEmpty) {
          var returnJson = jsonDecode(response.body);
          if (returnJson.containsKey("message")) {
            return {'error': returnJson["message"]};
          }
        }
        return {'error': response.reasonPhrase};
      case 422:
        if (response.body.isNotEmpty) {
          var returnJson = jsonDecode(response.body);
          if (returnJson.containsKey("message")) {
            return {'error': returnJson["message"]};
          }
        }
        return {'error': response.reasonPhrase};

      case 500:
        return {
          "error":
              "Internal server error, Please refresh or retry after some time."
        };
      default:
        return {'error': response.reasonPhrase};
    }
  }

  Map<String, dynamic> getResponseBody(
      http.Response response, bool isFileRequest) {
    Map<String, dynamic> _responseBody = {};
    if (response.body.isNotEmpty && !isFileRequest) {
      /// decode the response
      var _jsonResponse = json.decode(response.body);

      /// Check if _responseBody is not Map and do not contains key ['data'] and ['error] then add that _responseBody with key 'data'
      /// Required for GIS API Call
      if (_jsonResponse is! Map ||
          (_jsonResponse['data'] == null && _jsonResponse['error'] == null)) {
        _responseBody = {'data': _jsonResponse};
      } else {
        _responseBody = _jsonResponse as Map<String, dynamic>;
      }
    } else if (response.body.isNotEmpty && isFileRequest) {
      String _base64String = base64.encode(response.bodyBytes);
      Uint8List _bytes = base64.decode(_base64String);
      _responseBody['file'] = _bytes;
    } else {
      _responseBody = {
        'error': {'code': 1111, 'message': 'Unexpected error'}
      };
    }
    return _responseBody;
  }
}
