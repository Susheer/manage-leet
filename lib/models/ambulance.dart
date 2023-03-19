import 'package:flutter/cupertino.dart';

class AmbulanceModel extends ChangeNotifier{
  final int registredDate;
  final int? lastService;
  final String displayName;
  final String authorityDisplayName;
  final String? driverName;
  final String mobileNo;
  bool isActive;
  final String description;
  set setActive(bool state) {
    isActive = state;
    notifyListeners();
  }
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
