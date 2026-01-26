class MedicineModel {
  final String name;
  final String type;
  final String dose;
  final int amount;
  final DateTime endAt;
  final String alarmAt;
  final String rebeatEvery;
  String nextDose;

  MedicineModel({
    required this.name,
    required this.type,
    required this.dose,
    required this.amount,
    required this.endAt,
    required this.alarmAt,
    required this.rebeatEvery,
    required this.nextDose,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      name: json['name'],
      type: json['type'],
      dose: json['dose'],
      amount: int.parse(json['amount']),
      endAt: DateTime.parse(json['endAt']),
      alarmAt: json['alarmAt'],
      rebeatEvery: json['rebeatEvery'],
      nextDose: json['nextDose'],
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
      'rebeatEvery': model.rebeatEvery,
      'nextDose': model.nextDose,
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

  void setNextDose(String date) {
    nextDose = date;
  }
}
