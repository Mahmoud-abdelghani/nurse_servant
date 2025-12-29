import 'dart:developer';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nurse_servant/core/services/hive_service.dart';
import 'package:nurse_servant/features/home/data/models/medicine_model.dart';

part 'load_from_hive_state.dart';

class LoadFromHiveCubit extends Cubit<LoadFromHiveState> {
  LoadFromHiveCubit() : super(LoadFromHiveInitial());
  void storeInHive(MedicineModel medicineModel) {
    try {
      emit(LoadToHiveLoading());
      HiveService.hiveStoreMedicine(medicineModel: medicineModel);
      emit(LoadToHiveSuccess());
    } on Exception catch (e) {
      emit(LoadToHiveError(message: e.toString()));
    }
  }

  void getDataFromHive() {
    try {
      emit(LoadFromHiveLoading());
      List<MedicineModel> medicines = HiveService.getMedicineStoredInAList();
      try {
        if (medicines.isNotEmpty) {
          medicines.sort(
            (a, b) =>
                (int.parse(a.alarmAt.split(':').first) - DateTime.now().hour)
                    .isNegative
                ? 100 *
                      -(int.parse(a.alarmAt.split(':').first) -
                          DateTime.now().hour)
                : (int.parse(a.alarmAt.split(':').first) - DateTime.now().hour)
                      .compareTo(
                        (int.parse(b.alarmAt.split(':').first).toInt() -
                                    DateTime.now().hour)
                                .isNegative
                            ? 100 *
                                  -(int.parse(
                                        b.alarmAt.split(':').first,
                                      ).toInt() -
                                      DateTime.now().hour)
                            : (int.parse(b.alarmAt.split(':').first).toInt() -
                                  DateTime.now().hour),
                      ),
          );
        }
      } on Exception catch (e) {
        emit(LoadFromHiveError(message: e.toString()));
      }
      medicines.isEmpty
          ? emit(LoadFromHiveSuccessButEmpty())
          : emit(LoadFromHiveSuccess(mediciens: medicines));
    } on Exception catch (e) {
      emit(LoadFromHiveError(message: e.toString()));
    }
  }

  void removeElement(MedicineModel medicineModel) async {
    try {
      emit(RemovingLoading());
      List<MedicineModel> medicines = HiveService.getMedicineStoredInAList();
      int index = 0;
      for (var element in medicines) {
        if (element.isEqual(medicineModel)) {
          index = medicines.indexOf(element);
        }
      }
      await HiveService.removeElemet(index);
      emit(RemovingSuccess());
    } on Exception catch (e) {
      emit(RemovingError(message: e.toString()));
    }
  }
}
