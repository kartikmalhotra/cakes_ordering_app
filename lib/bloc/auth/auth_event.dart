part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  final bool fromSignupPage;

  const LoginEvent({
    required this.email,
    required this.password,
    this.fromSignupPage = false,
  });

  @override
  List<Object> get props => [email, password];
}

class DeleteAccountEvent extends AuthEvent {
  const DeleteAccountEvent();

  @override
  List<Object> get props => [];
}

class ForgetPasswordEvent extends AuthEvent {
  final String email;
  final DateTime dateTime;

  const ForgetPasswordEvent({required this.email, required this.dateTime});

  @override
  List<Object> get props => [email, dateTime];
}

class LogoutEvent extends AuthEvent {
  final DateTime dateTime;
  const LogoutEvent({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String phone;
  final String name;

  const SignUpEvent({
    required this.email,
    required this.password,
    required this.phone,
    required this.name,
  });

  @override
  List<Object> get props => [
        email,
        password,
        phone,
        name,
      ];
}
