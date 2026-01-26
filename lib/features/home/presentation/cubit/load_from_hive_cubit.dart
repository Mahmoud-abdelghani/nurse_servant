import 'dart:developer';

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

  Future<void> getDataFromHive() async {
    try {
      emit(LoadFromHiveLoading());
      log('prepare data : ');
      List<MedicineModel> medicines = HiveService.getMedicineStoredInAList();
      log(medicines.length.toString());
      List<MedicineModel> upToDateMedicine = [];
      log(upToDateMedicine.length.toString());
      try {
        if (medicines.isNotEmpty) {
          for (var element in medicines) {
            if (element.endAt.isAfter(DateTime.now())) {
              upToDateMedicine.add(element);
            }
          }
          if (upToDateMedicine.length > medicines.length) {
            upToDateMedicine.removeLast();
          }
          log(upToDateMedicine.length.toString());
          log('elmoktaaaaar');
          log(upToDateMedicine.length.toString());
          for (var element in upToDateMedicine) {
            if (int.parse(element.nextDose.split(':').first) <
                DateTime.now().hour) {
              while (int.parse(element.nextDose.split(':').first) <
                  DateTime.now().hour) {
                element.nextDose =
                    '${int.parse(element.nextDose.split(':').first) + int.parse(element.rebeatEvery.split(':').first)}:${element.nextDose.split(':').last}';
              }
              if (int.parse(element.nextDose.split(':').first) >= 24) {
                if (int.parse(element.nextDose.split(':').first) - 24 <= 2) {
                  element.nextDose =
                      '${int.parse(element.nextDose.split(':').first) - 24}:${element.nextDose.split(':').last}';
                } else {
                  element.nextDose = element.alarmAt;
                }
              }
            }
          }

          upToDateMedicine.sort(
            (a, b) =>
                (int.parse(a.nextDose.split(':').first) - DateTime.now().hour)
                    .isNegative
                ? 100 *
                      -(int.parse(a.nextDose.split(':').first) -
                          DateTime.now().hour)
                : (int.parse(a.nextDose.split(':').first) - DateTime.now().hour)
                      .compareTo(
                        (int.parse(b.nextDose.split(':').first).toInt() -
                                    DateTime.now().hour)
                                .isNegative
                            ? 100 *
                                  -(int.parse(
                                        b.nextDose.split(':').first,
                                      ).toInt() -
                                      DateTime.now().hour)
                            : (int.parse(b.nextDose.split(':').first).toInt() -
                                  DateTime.now().hour),
                      ),
          );
        }
      } on Exception catch (e) {
        emit(LoadFromHiveError(message: e.toString()));
      }
      upToDateMedicine.isEmpty
          ? emit(LoadFromHiveSuccessButEmpty())
          : emit(LoadFromHiveSuccess(mediciens: upToDateMedicine));
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
