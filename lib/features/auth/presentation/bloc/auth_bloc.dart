import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository_impl.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepositoryImpl _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AuthCheckRequested>((event, emit) async {
      emit(AuthLoading());
      final loggedIn = await _authRepository.isLoggedIn();
      if (loggedIn) {
        final result = await _authRepository.getBiodata();
        result.fold(
          (failure) => emit(AuthUnauthenticated()),
          (biodata) => emit(AuthAuthenticated(biodata)),
        );
      } else {
        emit(AuthUnauthenticated());
      }
    });

    on<AuthLoginRequested>((event, emit) async {
      emit(AuthLoading());
      final loginResult = await _authRepository.loginWithEmail(event.email);
      await loginResult.fold(
        (failure) async => emit(AuthFailure(failure)),
        (token) async {
          final biodataResult = await _authRepository.getBiodata();
          biodataResult.fold(
            (failure) => emit(AuthFailure(failure)),
            (biodata) => emit(AuthAuthenticated(biodata)),
          );
        },
      );
    });

    on<AuthLogoutRequested>((event, emit) async {
      emit(AuthLoading());
      await _authRepository.logout();
      emit(AuthUnauthenticated());
    });
  }
}
