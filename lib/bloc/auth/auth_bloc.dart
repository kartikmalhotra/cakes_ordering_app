import 'package:equatable/equatable.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodeasecakes/bloc/cake/cake_bloc.dart';
import 'package:foodeasecakes/config/application.dart';
import 'package:foodeasecakes/config/constants.dart';
import 'package:foodeasecakes/main.dart';
import 'package:foodeasecakes/repository/auth_repository.dart';

import 'package:foodeasecakes/utils/utils.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepositoryImpl repository;

  AuthBloc({required this.repository}) : super(const AuthInitial()) {
    on<LoginEvent>((event, emit) => _mapLoginEventToState(event, emit));
    on<ForgetPasswordEvent>(
        (event, emit) => _mapForgetPasswordEventToState(event, emit));
    on<LogoutEvent>((event, emit) => _mapLogoutEventToState(emit));
    on<SignUpEvent>((event, emit) => _mapSignUpEventToState(event, emit));
    on<DeleteAccountEvent>(
      (event, emit) => _mapDeleteAccountEventToState(emit),
    );
  }

  Future<void> _mapLoginEventToState(
      LoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoader());
    final response = await repository.login(event.email, event.password);
    if (response != null && response?['error'] == null) {
      _saveSecureStorage(response, event.email, event.password);
      // Application.firebaseAnalyticsService!.logLoginIn();
      if (event.fromSignupPage) {
        Application.localStorageService?.checkSubscriptionPurchased = false;
      }

      emit(LoginResultState(
        loggedIn: true,
        fromSignupPage: event.fromSignupPage,
      ));
    } else {
      emit(LoginResultState(
        loggedIn: false,
        errorResult: response?['error'] ?? "Somthing went wrong",
        fromSignupPage: event.fromSignupPage,
      ));
    }
  }

  Future<void> _mapForgetPasswordEventToState(
      ForgetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(const ForgetPasswordLoader());
    final response = await repository.forgetPassword(event.email);
    if (response != null && response['message'] != null) {
      emit(ForgetPasswordState(message: response['message']));
    } else {
      emit(ForgetPasswordState(
          errorResult:
              response?["error"].toString() ?? "Something went wrong"));
    }
  }

  Future<void> _mapSignUpEventToState(
      SignUpEvent event, Emitter<AuthState> emit) async {
    emit(const SignUpLoader());

    final response = await repository.signUp(
        event.email, event.password, event.name, event.phone);
    if (response == 200 || response?['error'] == null) {
      Utils.showSuccessToast("Your account is created successfully");
      Navigator.pop(App.globalContext);
      emit(SignupResultState(signedUp: true));
      // Application.firebaseAnalyticsService!.logSignUp(event.email);
    } else {
      emit(SignupResultState(
          errorResult: response?['error'] ?? "Somthing went wrong"));
    }
  }

  Future<void> _mapLogoutEventToState(emit) async {
    emit(const AuthLoader());
    final response = await repository.logout();
    if (response == null || response?['error'] == null) {
      Navigator.pop(App.globalContext);
      await logoutUser();
      BlocProvider.of<CakeBloc>(App.globalContext)
          .add(GetCakesEvent(dateTime: DateTime.now()));
      emit(const LogoutState(isLogout: true));
    } else {
      emit(const LogoutState(isLogout: false));
    }
  }

  Future<void> _mapDeleteAccountEventToState(emit) async {
    emit(LogoutLoader(dateTime: DateTime.now()));
    final response = await repository.deleteAccount();

    if (response['error'] == null) {
      Navigator.pop(App.globalContext);
      await logoutUser();
      BlocProvider.of<CakeBloc>(App.globalContext)
          .add(GetCakesEvent(dateTime: DateTime.now()));
      emit(const DeleteState(isDeleted: true));
    } else {
      emit(const DeleteState(isDeleted: false));
    }
  }

  void _saveSecureStorage(response, email, password) {
    // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    // _firebaseMessaging.getToken().then((token) {
    //   print("FCM Token is " + (token ?? ""));
    //   sendTokenToServer(token);
    // });

    /// Store in Class
    AppUser.authToken = response["accessToken"];
    AppUser.email = email;
    AppUser.password = password;
    AppUser.firebaseToken = response["refreshToken"];
    AppUser.isLoggedIn = true;

    /// Store in Storage
    Application.localStorageService!.isUserLoggedIn = AppUser.isLoggedIn;
    Application.secureStorageService!.authToken =
        Future.value(AppUser.authToken);
    Application.secureStorageService!.email = Future.value(AppUser.email);
    Application.secureStorageService!.password = Future.value(AppUser.password);
    // Application.secureStorageService!.refreshToken =
    //     Future.value(AppUser.firebaseToken);

    // Application.firebaseAnalyticsService!.setUserId(id: AppUser.email);

    if (kDebugMode) {
      print(AppUser.authToken);
    }
  }

  Future<void> logoutUser() async {
    try {
      AppUser.email =
          AppUser.password = AppUser.firebaseToken = AppUser.authToken = null;
      AppUser.isLoggedIn = false;
      Application.localStorageService!.removeDataFromLocalStorage();
      await Application.secureStorageService!.deleteAllDataFromSecureStorage();
    } catch (exe) {}
  }

  void sendTokenToServer(String? value) async {
    if (value != null && AppUser.firebaseToken != null) {
      try {
        var response = await Application.restService!.requestCall(
            apiEndPoint: "/api/mobile-tokens",
            requestParmas: {"mobileToken": value},
            addAutherization: true,
            method: RestAPIRequestMethods.post);
        if (kDebugMode) {
          print("Firebase token sent to server" + response.toString());
        }
      } catch (exe) {
        if (kDebugMode) {
          print("Firebase Exeception $exe");
        }
      }
    }
  }
}
