import 'package:hive/hive.dart';
import 'package:nurse_servant/features/home/data/models/medicine_model.dart';

class MedicineModelTypeAdapter extends TypeAdapter<MedicineModel> {
  @override
  MedicineModel read(BinaryReader reader) {
    return MedicineModel(
      name: reader.readString(),
      type: reader.readString(),
      dose: reader.readString(),
      amount: reader.readInt(),
      endAt: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      alarmAt: reader.readString(),
    );
  }

  @override
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, MedicineModel obj) {
    writer.writeString(obj.name);
    writer.writeString(obj.type);
    writer.writeString(obj.dose);
    writer.writeInt(obj.amount);
    writer.writeInt(obj.endAt.microsecondsSinceEpoch);
    writer.writeString(obj.alarmAt);
  }
}
