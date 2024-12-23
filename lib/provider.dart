import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());

class AuthState {
  final bool isAuthenticated;
  final String? token;
  final String? error;
  final List<dynamic>? users;
  final List<dynamic>? filteredUsers;
  final List<String>? specialties;

  AuthState({
    this.isAuthenticated = false,
    this.token,
    this.error,
    this.users,
    this.filteredUsers,
    this.specialties,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? token,
    String? error,
    List<dynamic>? users,
    List<dynamic>? filteredUsers,
    List<String>? specialties,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      token: token ?? this.token,
      error: error ?? this.error,
      users: users ?? this.users,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      specialties: specialties ?? this.specialties,
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
    try {
      final response = await _dio.get(
        'https://rxbackend.crp-carerapidpoint.com/api/auth/all-users',
      );

      if (response.statusCode == 200) {
        final specialties = (response.data as List<dynamic>)
            .map((user) => user['speciality']?.toString() ?? '')
            .toSet()
            .toList();

        state = state.copyWith(
          users: response.data,
          filteredUsers: response.data,
          specialties: specialties,
        );
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

  void filterDoctors(String query, [String specialty = ""]) {
    final users = state.users ?? [];

    final filtered = users.where((user) {
      final matchesQuery = query.isEmpty ||
          (user['displayName'] ?? '')
              .toLowerCase()
              .contains(query.toLowerCase()) ||
          (user['work_at'] ?? '').toLowerCase().contains(query.toLowerCase());

      final matchesSpecialty =
          specialty.isEmpty || (user['speciality'] ?? '') == specialty;

      return matchesQuery && matchesSpecialty;
    }).toList();

    state = state.copyWith(filteredUsers: filtered);
  }

  void filterBySpecialty(String specialty) {
    filterDoctors("", specialty);
  }

  void logout() {
    state = AuthState(isAuthenticated: false);
  }
}
