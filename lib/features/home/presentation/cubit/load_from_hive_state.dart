part of 'load_from_hive_cubit.dart';

@immutable
sealed class LoadFromHiveState {}

final class LoadFromHiveInitial extends LoadFromHiveState {}

final class LoadToHiveLoading extends LoadFromHiveState {}

final class LoadToHiveSuccess extends LoadFromHiveState {}

final class LoadToHiveError extends LoadFromHiveState {
  final String message;
  LoadToHiveError({required this.message});
}

final class LoadFromHiveLoading extends LoadFromHiveState {}

final class LoadFromHiveSuccess extends LoadFromHiveState {
  final List<MedicineModel> mediciens;
  LoadFromHiveSuccess({required this.mediciens});
}

final class LoadFromHiveSuccessButEmpty extends LoadFromHiveState {}

final class LoadFromHiveError extends LoadFromHiveState {
  final String message;
  LoadFromHiveError({required this.message});
}

final class RemovingLoading extends LoadFromHiveState {}

final class RemovingSuccess extends LoadFromHiveState {}

final class RemovingError extends LoadFromHiveState {
  final String message;
  RemovingError({required this.message});
}
