class ReportModel {
  int? id;
  Map<String, dynamic>? user;
  String? employeeUid;
  final String facility;
  final String description;
  final String location;
  final String imagePath;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReportModel({
    this.id,
    this.user,
    this.employeeUid,
    required this.facility,
    required this.description,
    required this.location,
    required this.imagePath,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, String> toMap() {
    return {
      "facility": facility,
      "description": description,
      "location": location,
    };
  }

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map["id"],
      user: map["user"],
      facility: map["facility"],
      description: map["description"],
      location: map["location"],
      imagePath: map["picture_path"],
      status: map["status"],
      createdAt: DateTime.parse(map["created_at"]),
      updatedAt: DateTime.parse(map["updated_at"]),
    );
  }
}
