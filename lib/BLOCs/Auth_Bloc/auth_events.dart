abstract class AuthEvent {}

class GoogleLoginRequested extends AuthEvent {} // New event

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;

  SignUpRequested(this.email, this.password);
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);
}

class LogoutRequested extends AuthEvent {}
