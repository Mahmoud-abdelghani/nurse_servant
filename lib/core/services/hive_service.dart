import 'package:hive_flutter/hive_flutter.dart';
import 'package:nurse_servant/features/home/data/models/medicine_model.dart';

class HiveService {
  static late Box box;
  static Future<void> hiveBoxInitialization() async {
    box = await Hive.openBox('medicineTable');
  }

  static void hiveStoreMedicine({required MedicineModel medicineModel}) {
    box.add(medicineModel);
  }

  static List<MedicineModel> getMedicineStoredInAList() {
    return List.generate(box.length, (index) => box.getAt(index));
  }

  static void clearBox() {
    box.clear();
  }

  static Future< void> removeElemet(int index) async {
 await   box.deleteAt(index);
  }
}
