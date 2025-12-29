class MedicineModel {
  final String name;
  final String type;
  final String dose;
  final int amount;
  final DateTime endAt;
  final String alarmAt;

  MedicineModel({
    required this.name,
    required this.type,
    required this.dose,
    required this.amount,
    required this.endAt,
    required this.alarmAt,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      name: json['name'],
      type: json['type'],
      dose: json['dose'],
      amount: int.parse(json['amount']),
      endAt: DateTime.parse(json['endAt']),
      alarmAt: json['alarmAt'],
    );
  }

  static Map<String, dynamic> toJson(MedicineModel model) {
    return {
      'name': model.name,
      'type': model.type,
      'dose': model.dose,
      'amount': model.amount.toString(),
      'endAt': model.endAt.toString(),
      'alarmAt': model.alarmAt,
    };
  }

  bool isEqual(MedicineModel medicineModel) {
    if (name == medicineModel.name &&
        endAt == medicineModel.endAt &&
        dose == medicineModel.dose) {
      return true;
    } else {
      return false;
    }
  }
}
