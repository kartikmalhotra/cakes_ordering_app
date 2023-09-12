part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class GetUserProfileEvent extends ProfileEvent {
  final DateTime dateTime;
  const GetUserProfileEvent({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}
