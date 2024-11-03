import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());

class AuthState {
  final bool isAuthenticated;
  final String? token;
  final String? error;

  AuthState({this.isAuthenticated = false, this.token, this.error});

  AuthState copyWith({bool? isAuthenticated, String? token, String? error}) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      token: token ?? this.token,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  Future<void> login(String username, String password) async {
    final dio = Dio();
    try {
      final response = await dio.post(
        'https://rxbackend.crp-carerapidpoint.com/api/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      // print('Response Data: ${response.data}');

      if (response.statusCode == 200 && response.data['access_token'] != null) {
        state = state.copyWith(
          isAuthenticated: true,
          token: response.data['access_token'],
        );
      } else {
        state = state.copyWith(
          isAuthenticated: false,
          error: 'Login failed. Please try again.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isAuthenticated: false,
        error: 'An error occurred: $e',
      );
    }
  }

  void logout() {
    state = AuthState(isAuthenticated: false);
  }
}
