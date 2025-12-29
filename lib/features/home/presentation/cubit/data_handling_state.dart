part of 'data_handling_cubit.dart';

@immutable
sealed class DataHandlingState {}

final class DataHandlingInitial extends DataHandlingState {}

final class CreatingNewUserLoading extends DataHandlingState {}

final class CreatingNewUserSuccess extends DataHandlingState {
  List<dynamic> jsons;
  CreatingNewUserSuccess({required this.jsons});
}

final class CreatingNewUserError extends DataHandlingState {
  final String message;
  CreatingNewUserError({required this.message});
}

final class SyncUserLoading extends DataHandlingState {}

final class SyncUserSuccess extends DataHandlingState {
  
}

final class SyncUserError extends DataHandlingState {
  final String message;
  SyncUserError({required this.message});
}
