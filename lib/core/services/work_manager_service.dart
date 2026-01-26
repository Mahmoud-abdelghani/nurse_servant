import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:nurse_servant/core/services/hive_service.dart';
import 'package:nurse_servant/core/services/local_notification_service.dart';
import 'package:nurse_servant/features/home/data/models/medicine_model.dart';
import 'package:nurse_servant/features/home/data/models/medicine_model_type_adapter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workmanager/workmanager.dart';

class WorkManagerService {
  static Future<void> workManagerInitialzation() async {
    Workmanager().initialize(callbackDispatcher);
    await regesterTasks();
  }

  static Future<void> regesterTasks() async {
    Workmanager().registerPeriodicTask(
      'Medicine_Alarms',
      'Medicine_Alarms',
      frequency: Duration(hours: 1),
    );
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case "Medicine_Alarms":
        {
          final dir = await getApplicationDocumentsDirectory();
          Hive.init(dir.path);

          if (!Hive.isAdapterRegistered(0)) {
            Hive.registerAdapter(MedicineModelTypeAdapter());
          }
          await HiveService.hiveBoxInitialization();
          List<MedicineModel> medicines =
              HiveService.getMedicineStoredInAList();
          List<MedicineModel> upToDateMedicine = [];
          if (medicines.isNotEmpty) {
            for (var element in medicines) {
              if (element.endAt.isAfter(DateTime.now())) {
                upToDateMedicine.add(element);
              }
            }
            // upToDateMedicine = medicines
            //     .where((element) => element.endAt.isAfter(DateTime.now()))
            //     .toList();
            if (upToDateMedicine.length > medicines.length) {
              upToDateMedicine.removeLast();
            }
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

            // for (var element in upToDateMedicine) {
            //   element.nextDose =
            //       int.parse(element.nextDose.split(':').first) >
            //           DateTime.now().hour
            //       ? element.nextDose
            //       : '${(int.parse(element.nextDose.split(':').first) + int.parse(element.rebeatEvery.split(':').first))}:${element.nextDose.split(':').last}';
            //   if (int.parse(element.nextDose.split(':').first) >= 24) {
            //     element.nextDose = element.alarmAt;
            //   }
            // }

            upToDateMedicine.sort(
              (a, b) =>
                  (int.parse(a.nextDose.split(':').first) - DateTime.now().hour)
                      .isNegative
                  ? 100 *
                        -(int.parse(a.nextDose.split(':').first) -
                            DateTime.now().hour)
                  : (int.parse(a.nextDose.split(':').first) -
                            DateTime.now().hour)
                        .compareTo(
                          (int.parse(b.nextDose.split(':').first).toInt() -
                                      DateTime.now().hour)
                                  .isNegative
                              ? 100 *
                                    -(int.parse(
                                          b.nextDose.split(':').first,
                                        ).toInt() -
                                        DateTime.now().hour)
                              : (int.parse(
                                      b.nextDose.split(':').first,
                                    ).toInt() -
                                    DateTime.now().hour),
                        ),
            );
            for (int i = 0; i < upToDateMedicine.length; i++) {
              log('$i - ${upToDateMedicine[i].nextDose}');
              await LocalNotificationService.deleteNotificationById(i);
              await LocalNotificationService.setshadualedNotification(
                id: i,
                title: 'Medicine Alarm',
                body: upToDateMedicine[i].name,
                hour: int.parse(upToDateMedicine[i].nextDose.split(':').first),
                min: int.parse(upToDateMedicine[i].nextDose.split(':').last),
              );
            }
          } else {
            log('Error');
          }
          break;
        }

      default:
        // Handle unknown task types
        break;
    }

    return Future.value(true);
  });
}
