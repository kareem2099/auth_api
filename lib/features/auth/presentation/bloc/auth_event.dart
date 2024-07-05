part of 'auth_bloc.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthenticationEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class RegisterEvent extends AuthenticationEvent {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
  final Map<String, dynamic> location;
  final File? profilePic;

  const RegisterEvent({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
    required this.location,
    required this.profilePic,
  });

  @override
  List<Object> get props =>
      [name, email, phone, password, confirmPassword, location];
}

class UpdateUserEvent extends AuthenticationEvent {
  final String name;
  final String phone;
  final Map<String, dynamic> location;
  final File? profilePic;

  const UpdateUserEvent({
    required this.name,
    required this.phone,
    required this.location,
    this.profilePic,
  });

  @override
  List<Object> get props => [name, phone, location];
}

class DeleteUserEvent extends AuthenticationEvent {
  final String userId;

  const DeleteUserEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class LogoutEvent extends AuthenticationEvent {}

class GetUserEvent extends AuthenticationEvent {
  final String userId;

  const GetUserEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}
