class BedStatusModel {
  final String id;
  final int statusNumber;
  final String statusName;

  BedStatusModel({
    required this.id,
    required this.statusNumber,
    required this.statusName,
  });

  factory BedStatusModel.fromJson(Map<String, dynamic> json) {
    return BedStatusModel(
      id: json['_id'] as String? ?? '',
      statusNumber: json['statusNumber'] as int? ?? 0,
      statusName: json['statusName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'statusNumber': statusNumber,
      'statusName': statusName,
    };
  }
}
