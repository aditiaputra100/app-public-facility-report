class ReportModel {
  int? id;
  final String userUid;
  String? employeeUid;
  final String facility;
  final String description;
  final String location;
  final String imagePath;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReportModel({
    required this.userUid,
    required this.facility,
    required this.description,
    required this.location,
    required this.imagePath,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
}
