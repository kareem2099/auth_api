import 'dart:convert';
import 'dart:io';

import 'package:auth_api/features/auth/domain/repo/reg_repo.dart';
import 'package:auth_api/features/auth/domain/repo/login_repo.dart';
import 'package:auth_api/features/auth/domain/repo/update_repo.dart';
import 'package:auth_api/features/auth/domain/repo/delete_repo.dart';
import 'package:auth_api/features/auth/domain/repo/log_out_repo.dart';
import 'package:auth_api/features/auth/domain/repo/get_data_repo.dart';
import 'package:auth_api/features/auth/presentation/component/secure_storage_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final LoginRepo loginRepo;
  final RegisterRepo registerRepo;
  final UpdateRepo updateRepo;
  final DeleteRepo deleteRepo;
  final LogoutRepo logoutRepo;
  final GetUserRepo getUserRepo;
  final _secureStorage = const FlutterSecureStorage();

  AuthenticationBloc(
    this.loginRepo,
    this.registerRepo,
    this.updateRepo,
    this.deleteRepo,
    this.logoutRepo,
    this.getUserRepo,
  ) : super(AuthenticationInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<UpdateUserEvent>(_onUpdateUser);
    on<DeleteUserEvent>(_onDeleteUser);
    on<LogoutEvent>(_onLogout);
    on<GetUserEvent>(_onGetUser);
  }

  Future<void> _onLogin(
      LoginEvent event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    final res =
        await loginRepo.login(email: event.email, password: event.password);

    final responseBody = res['body'];
    final statusCode = res['statusCode'];

    if (statusCode == 200) {
      final token = responseBody['token'];

      // Save token
      await SecureStorageHelper.saveToken(token);

      emit(AuthenticationSuccess());
    } else if (statusCode == 403) {
      if (responseBody['ErrorMessage'] == 'invalid user information') {
        emit(const AuthenticationError(
            message: "Invalid user information as email or password"));
      } else if (responseBody['ErrorMessage'] == 'please confirm your email') {
        emit(const AuthenticationError(message: "Please confirm your email"));
      }
    } else {
      emit(const AuthenticationError(
          message: "The service is currently unavailable, please try again."));
    }
  }

  Future<void> _onRegister(
      RegisterEvent event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    final res = await registerRepo.register(
      name: event.name,
      email: event.email,
      phone: event.phone,
      password: event.password,
      confirmPassword: event.confirmPassword,
      location: event.location,
      profilePic: event.profilePic,
    );

    final responseBody = res['body'];
    final statusCode = res['statusCode'];

    if (statusCode == 200) {
      emit(AuthenticationSuccess());
    } else if (statusCode == 400) {
      if (responseBody['ErrorMessage'] ==
          'This email already exist but not confirmed') {
        emit(const AuthenticationError(
            message: "This email already exists but is not confirmed."));
      } else if (responseBody['ErrorMessage'] == 'This email already exist') {
        emit(const AuthenticationError(message: "This email already exists"));
      } else {
        emit(const AuthenticationError(
            message: "Registration failed. Please try again."));
      }
    } else {
      emit(const AuthenticationError(
          message: "The service is currently unavailable, please try again."));
    }
  }

  Future<void> _onUpdateUser(
      UpdateUserEvent event, Emitter<AuthenticationState> emit) async {
    emit(UserUpdateLoading());
    try {
      final token = await _secureStorage.read(
          key: 'token'); // Retrieve token from secure storage
      if (token == null) {
        emit(const UserUpdateError(message: "Token is missing"));
        return;
      }
      final res = await updateRepo.updateUserData(
          name: event.name,
          phone: event.phone,
          location: event.location,
          profilePic: event.profilePic);
      if (res[1] == 202) {
        emit(UserUpdateSuccess());
      } else if (res[1] == 400) {
        emit(UserUpdateError(message: res[0]));
      } else {
        emit(const UserUpdateError(
            message:
                "The service is currently unavailable, please try again."));
      }
    } catch (e) {
      emit(UserUpdateError(message: e.toString()));
    }
  }

  Future<void> _onDeleteUser(
      DeleteUserEvent event, Emitter<AuthenticationState> emit) async {
    emit(UserDeleteLoading());
    final res = await deleteRepo.deleteUser(event.userId);
    // Print the user ID

    if (res[1] == 200) {
      emit(UserDeleteSuccess());
    } else if (res[1] == 400) {
      emit(const UserDeleteError(message: "Invalid user ID"));
    } else {
      emit(const UserDeleteError(
          message: "The service is currently unavailable, please try again."));
    }
  }

  Future<void> _onLogout(
      LogoutEvent event, Emitter<AuthenticationState> emit) async {
    emit(LogoutLoading());
    final res = await logoutRepo.logout();

    if (res[1] == 200) {
      emit(LogoutSuccess());
    } else if (res[1] == 400) {
      emit(const LogoutError(message: "Invalid token"));
    } else {
      emit(const LogoutError(
          message: "The service is currently unavailable, please try again."));
    }
  }

  Future<void> _onGetUser(
      GetUserEvent event, Emitter<AuthenticationState> emit) async {
    emit(GetUserLoading());
    final res = await getUserRepo.getUserData(event.userId);

    if (res[1] == 200) {
      emit(GetUserSuccess(userData: jsonDecode(res[0])));
    } else if (res[1] == 400) {
      emit(const GetUserError(message: "Invalid user ID"));
    } else {
      emit(const GetUserError(
          message: "The service is currently unavailable, please try again."));
    }
  }
}
