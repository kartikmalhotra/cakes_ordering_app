part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileLoadedState extends ProfileState {
  final UserProfile? userProfile;
  final String? errorMessage;

  ProfileLoadedState({this.userProfile, this.errorMessage});

  @override
  List<Object?> get props => [userProfile, errorMessage];
}
