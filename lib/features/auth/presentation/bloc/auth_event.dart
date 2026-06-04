abstract class AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  AuthLoginRequested(this.email);
}

class AuthLogoutRequested extends AuthEvent {}
