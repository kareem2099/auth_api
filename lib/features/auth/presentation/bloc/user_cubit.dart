import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class UserState extends Equatable {
  final String name;
  final String phone;
  final String locationName;
  final String locationAddress;
  final String locationCoordination;
  final String imageUrl;

  const UserState({
    this.name = '',
    this.phone = '',
    this.locationName = '',
    this.locationAddress = '',
    this.locationCoordination = '',
    this.imageUrl = '',
  });

  @override
  List<Object> get props => [
    name,
    phone,
    locationName,
    locationAddress,
    locationCoordination,
    imageUrl,
  ];

  UserState copyWith({
    String? name,
    String? phone,
    String? locationName,
    String? locationAddress,
    String? locationCoordination,
    String? imageUrl,
  }) {
    return UserState(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      locationName: locationName ?? this.locationName,
      locationAddress: locationAddress ?? this.locationAddress,
      locationCoordination:
      locationCoordination ?? this.locationCoordination,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserState());

  void updateUser({
    String? name,
    String? phone,
    String? locationName,
    String? locationAddress,
    String? locationCoordination,
    String? imageUrl,
  }) {
    emit(state.copyWith(
      name: name,
      phone: phone,
      locationName: locationName,
      locationAddress: locationAddress,
      locationCoordination: locationCoordination,
      imageUrl: imageUrl,
    ));
  }
}