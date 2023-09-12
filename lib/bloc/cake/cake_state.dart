part of 'cake_bloc.dart';

@immutable
abstract class CakeState {
  const CakeState();
}

class CakeLoader extends CakeState {
  @override
  List<Object> get props => [];
}

class CakeInitial extends CakeState {
  @override
  List<Object> get props => [];
}

class CakesLoadedState extends CakeState {
  final String? errorResult;
  final CakesDataModel? cakesDataModel;

  CakesLoadedState({this.errorResult, this.cakesDataModel});

  @override
  List<Object?> get props => [errorResult, cakesDataModel];
}
