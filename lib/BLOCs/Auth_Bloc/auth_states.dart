import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user; // Firebase User object

  AuthAuthenticated(this.user);
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class AuthLoggedOut extends AuthState {}
