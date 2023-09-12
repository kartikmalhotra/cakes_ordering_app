import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:foodeasecakes/config/application.dart';
import 'package:foodeasecakes/config/routes/routes_const.dart';
import 'package:foodeasecakes/main.dart';
import 'package:foodeasecakes/models/users_model.dart';
import 'package:foodeasecakes/repository/profile_repository.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepositoryImpl repository;

  ProfileBloc({required this.repository}) : super(ProfileInitial()) {
    on<GetUserProfileEvent>(
        (event, emit) => _mapGetUserProfileEventToState(event, emit));
  }

  Future<void> _mapGetUserProfileEventToState(
      GetUserProfileEvent event, Emitter<ProfileState> emit) async {
    var response = await repository.getUserProfile();
    if (response != null && response["error"] == null) {
      UserProfile userProfile = UserProfile.fromJson(response);
      Application.userProfile = userProfile;
      emit(ProfileLoadedState(userProfile: userProfile));
    } else {
      if (response?["error"] == "Unauthorized") {
        Navigator.pushNamedAndRemoveUntil(
            App.globalContext, AppRoutes.login, (route) => false);
      }
      emit(ProfileLoadedState(
          errorMessage: response?["error"] ?? "Something went wrong"));
    }
  }
}
