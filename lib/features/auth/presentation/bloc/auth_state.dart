part of 'auth_bloc.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {}

class AuthenticationError extends AuthenticationState {
  final String message;

  const AuthenticationError({required this.message});

  @override
  List<Object> get props => [message];
}

class UserUpdateLoading extends AuthenticationState {}

class UserUpdateSuccess extends AuthenticationState {}

class UserUpdateError extends AuthenticationState {
  final String message;

  const UserUpdateError({required this.message});

  @override
  List<Object> get props => [message];
}

class UserDeleteLoading extends AuthenticationState {}

class UserDeleteSuccess extends AuthenticationState {}

class UserDeleteError extends AuthenticationState {
  final String message;

  const UserDeleteError({required this.message});

  @override
  List<Object> get props => [message];
}

class LogoutLoading extends AuthenticationState {}

class LogoutSuccess extends AuthenticationState {}

class LogoutError extends AuthenticationState {
  final String message;

  const LogoutError({required this.message});

  @override
  List<Object> get props => [message];
}

class GetUserLoading extends AuthenticationState {}

class GetUserSuccess extends AuthenticationState {
  final Map<String, dynamic> userData;

  const GetUserSuccess({required this.userData});

  @override
  List<Object> get props => [userData];
}

class GetUserError extends AuthenticationState {
  final String message;

  const GetUserError({required this.message});

  @override
  List<Object> get props => [message];
}
