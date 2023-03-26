
import 'package:flutter/material.dart';
import 'package:flutterapidemo/ext/extensions.dart';
import 'package:intl/intl.dart';

class AttendanceHistory {
  String? start;
  String? checkin;
  String? checkout;
  String? requestChangeWorkingTimeStatus;

  AttendanceHistory({this.start, this.checkin, this.checkout, this.requestChangeWorkingTimeStatus});

  DateTime? get date => DateTime.tryParse(start ?? "");

  String get displayDate => DateFormat('dd/MM').format(date!);
  String get displayFullDate => DateFormat('dd/MM/yyyy').format(date!);

  String get displayCheckinTime => checkin ?? "";
  String get displayCheckoutTime => checkout ?? "";


  bool get hasCheckin => checkin != null;
  bool get hasCheckout => checkout != null;

  bool get isRequestEditTimePending => requestChangeWorkingTimeStatus == 'SENT_REQUEST';

  void setRequestEditTimePending(TimeOfDay checkin, TimeOfDay checkout) {
    requestChangeWorkingTimeStatus == 'SENT_REQUEST';
    this.checkin = checkin.asStringWithSecond;
    this.checkout = checkout.asStringWithSecond;
  }

  factory AttendanceHistory.fromJson(dynamic json) {
    return AttendanceHistory(
      start: json['start'] as String?,
      checkin: json['checkinTime'] as String?,
      checkout: json['checkoutTime'] as String?,
      requestChangeWorkingTimeStatus: json['requestChangeWorkingTimeStatus'] as String?
    );
  }

  static List<AttendanceHistory> recipesFromSnapshot(List snapshot) {
    return snapshot.map((e) => AttendanceHistory.fromJson(e)).toList();
  }

}