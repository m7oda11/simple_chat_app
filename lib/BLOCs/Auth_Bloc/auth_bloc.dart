import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Services/auth_service.dart';
import 'auth_events.dart';
import 'auth_states.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc(this._authService) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _authService.signIn(event.email, event.password);
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthError("Login failed. Please check your credentials."));
        }
      } catch (e) {
        emit(AuthError(_handleAuthError(e)));
      }
    });

    on<GoogleLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _authService.signInWithGoogle();
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthError("Google sign-in failed."));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _authService.signUp(event.email, event.password);
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthError("Sign-up failed. Please try again."));
        }
      } catch (e) {
        emit(AuthError(_handleAuthError(e)));
      }
    });

    on<LogoutRequested>((event, emit) async {
      await _authService.signOut();
      emit(AuthLoggedOut());
    });
  }

  // Handle different types of authentication errors
  String _handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'The email address is not valid.';
        case 'user-not-found':
          return 'No user found for that email.';
        case 'wrong-password':
          return 'Incorrect password provided.';
        default:
          return 'An unknown error occurred.';
      }
    }
    return error.toString(); // Fallback for other errors
  }
}
