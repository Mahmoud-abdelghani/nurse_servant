part of 'authentication_cubit.dart';

@immutable
sealed class AuthenticationState {}

final class AuthenticationInitial extends AuthenticationState {}

final class AuthenticationGoogleLoading extends AuthenticationState {}

final class AuthenticationGoogleSuccess extends AuthenticationState {}

final class AuthenticationGoogleFail extends AuthenticationState {
  final String message;
  AuthenticationGoogleFail({required this.message});
}

final class RegisterLoading extends AuthenticationState {}

final class RegisterSuccess extends AuthenticationState {}

final class RegisterFail extends AuthenticationState {
  final String message;
  RegisterFail({required this.message});
}

final class LoginLoading extends AuthenticationState {}

final class LoginSuccess extends AuthenticationState {}

final class LoginFail extends AuthenticationState {
  final String message;
  LoginFail({required this.message});
}
final class LogoutLoading extends AuthenticationState {}

final class LogoutSuccess extends AuthenticationState {}

final class LogoutFail extends AuthenticationState {
  final String message;
  LogoutFail({required this.message});
}

final class PasswordResetConfirmLoading extends AuthenticationState {}

final class PasswordResetConfirmSuccess extends AuthenticationState {}

final class PasswordResetConfirmFail extends AuthenticationState {
  final String message;
  PasswordResetConfirmFail({required this.message});
} 

final class ResetPasswordLoading extends AuthenticationState {}

final class ResetPasswordSuccess extends AuthenticationState {}

final class ResetPasswordFail extends AuthenticationState {
  final String message;
  ResetPasswordFail({required this.message});
}

