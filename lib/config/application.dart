import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodeasecakes/bloc/bloc_observer.dart';
import 'package:foodeasecakes/config/routes/routes.dart';
import 'package:foodeasecakes/models/users_model.dart';
import 'package:foodeasecakes/services/firebase_analytics.dart';
import 'package:foodeasecakes/services/local_storage.dart';
import 'package:foodeasecakes/services/native_service.dart';
import 'package:foodeasecakes/services/rest_api_service.dart';
import 'package:foodeasecakes/services/secure_storage.dart';
import 'package:foodeasecakes/services/timezone_service.dart';

class Application {
  static String? preferedLanguage;
  static String? preferedTheme;
  static UserProfile? userProfile;
  // static UserDetails? userDetails;
  static Brightness? hostSystemBrightness;
  static LocalStorageService? localStorageService;
  static SecureStorageService? secureStorageService;
  static TimezoneService? timezoneService;
  static NativeAPIService? nativeAPIService;

  static AppBlocObserver? appBlocObserver;
  static AppRouteSetting? routeSetting;
  static RestAPIService? restService;
  static TargetPlatform platform =
      Platform.isIOS ? TargetPlatform.iOS : TargetPlatform.android;
}

abstract class AppUser {
  static bool? isLoggedIn;
  static String? authToken;
  static String? firebaseToken;
  static String? email;
  static String? password;
}
