import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());

class AuthState {
  final bool isAuthenticated;
  final String? token;
  final String? error;
  final List<dynamic>? users;

  AuthState({
    this.isAuthenticated = false,
    this.token,
    this.error,
    this.users,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? token,
    String? error,
    List<dynamic>? users,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      token: token ?? this.token,
      error: error ?? this.error,
      users: users ?? this.users,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  final Dio _dio = Dio();

  Future<void> login(String username, String password) async {
    try {
      final response = await _dio.post(
        'https://rxbackend.crp-carerapidpoint.com/api/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );

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

  Future<void> fetchAllUsers() async {
    if (state.token == null) {
      state = state.copyWith(error: 'User is not authenticated.');
      return;
    }

    try {
      final response = await _dio.get(
        'https://rxbackend.crp-carerapidpoint.com/api/auth/all-users',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${state.token}',
          },
        ),
      );

      if (response.statusCode == 200) {
        state = state.copyWith(users: response.data);
      } else {
        state = state.copyWith(
          error: 'Failed to fetch users. Please try again later.',
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'An error occurred while fetching users: $e',
      );
    }
  }

  void logout() {
    state = AuthState(isAuthenticated: false);
  }
}
