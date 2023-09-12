part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  List<Object?> get props => [];
}

class AuthLoader extends AuthState {
  const AuthLoader();

  @override
  List<Object?> get props => [];
}

class LogoutLoader extends AuthState {
  final DateTime dateTime;
  const LogoutLoader({required this.dateTime});

  @override
  List<Object?> get props => [dateTime];
}

class ForgetPasswordLoader extends AuthState {
  const ForgetPasswordLoader();

  @override
  List<Object?> get props => [];
}

class SignUpLoader extends AuthState {
  const SignUpLoader();

  @override
  List<Object?> get props => [];
}

class SignupResultState extends AuthState {
  final bool signedUp;
  final String? errorResult;

  const SignupResultState({
    this.signedUp = false,
    this.errorResult,
  });

  @override
  List<Object?> get props => [signedUp, errorResult];
}

class LoginResultState extends AuthState {
  final bool loggedIn;
  final String? errorResult;
  final bool fromSignupPage;

  const LoginResultState({
    required this.loggedIn,
    this.errorResult,
    this.fromSignupPage = false,
  });

  @override
  List<Object?> get props => [loggedIn, errorResult, fromSignupPage];
}

class ForgetPasswordState extends AuthState {
  final String? message;
  final String? errorResult;

  const ForgetPasswordState({
    this.message,
    this.errorResult,
  });

  @override
  List<Object?> get props => [message, errorResult];
}

class LogoutState extends AuthState {
  final bool isLogout;

  const LogoutState({required this.isLogout});

  @override
  List<Object?> get props => [isLogout];
}

class DeleteState extends AuthState {
  final bool isDeleted;

  const DeleteState({required this.isDeleted});

  @override
  List<Object?> get props => [isDeleted];
}
