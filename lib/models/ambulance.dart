class AmbulanceModel {
  final int registredDate;
  final int? lastService;
  final String displayName;
  final String authorityDisplayName;
  final String? driverName;
  final String mobileNo;
  final bool isActive;
  final String description;

  AmbulanceModel({
    required this.registredDate,
    this.lastService,
    required this.displayName,
    required this.authorityDisplayName,
    this.driverName,
    required this.isActive,
    required this.mobileNo,
    required this.description,
  });
}
