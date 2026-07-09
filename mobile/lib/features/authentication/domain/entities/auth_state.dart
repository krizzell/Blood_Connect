import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:blood_connect/features/authentication/data/models/models_export.dart';

part 'auth_state.freezed.dart';

/// Auth state entity using Freezed for immutability and pattern matching
@freezed
class AuthState with _$AuthState {
  /// Initial state when app starts
  const factory AuthState.initial() = _Initial;

  /// Loading state while authentication is in progress
  const factory AuthState.loading() = _Loading;

  /// Authenticated state with user data and token
  const factory AuthState.authenticated({
    required UserModel user,
    required String accessToken,
  }) = _Authenticated;

  /// Unauthenticated state (user not logged in)
  const factory AuthState.unauthenticated() = _Unauthenticated;

  /// Registration successful state (user should be redirected to login)
  const factory AuthState.registrationSuccess() = _RegisterSuccess;

  /// Error state with error message
  const factory AuthState.error({
    required String message,
  }) = _Error;
}
