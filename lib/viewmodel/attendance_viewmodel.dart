
import 'package:flutter/material.dart';
import 'package:flutterapidemo/ext/extensions.dart';
import 'package:flutterapidemo/model/attendance_history.dart';
import 'package:intl/intl.dart';
import '../service/bipower_service.dart';

class AttendanceViewModel extends ChangeNotifier {

  final BuildContext context;

  AttendanceViewModel({required this.context});

  bool isLoading = false;
  String? error;
  List<AttendanceHistory> attendanceHistories = [];

  NetworkService get networkService => NetworkService.instance;

  Future<List<AttendanceHistory>> getHistory() async {

    isLoading = true;
    notifyListeners();

    final result = await networkService.getHistory();

    if (result.isSuccess) {
      attendanceHistories = result.value ?? [];
      error = null;
    } else {
      error = result.error ?? "Có lỗi xảy ra!";
    }

    isLoading = false;
    notifyListeners();

    return attendanceHistories;
  }

  void checkin() async {
    final result = await networkService.checkin();

    isLoading = true;
    notifyListeners();

    if (result.isSuccess) {

      if(attendanceHistories.isNotEmpty) {
        attendanceHistories[0].checkin = DateFormat('HH:mm:ss').format(DateTime.now());
      }

      error = null;
    } else {
      error = result.error ?? "Có lỗi xảy ra!";
    }

    isLoading = false;
    notifyListeners();
  }

  void checkout() async {
    final result = await networkService.checkout();

    isLoading = true;
    notifyListeners();

    if (result.isSuccess) {

      if(attendanceHistories.isNotEmpty) {
        attendanceHistories[0].checkout = DateFormat('HH:mm:ss').format(DateTime.now());
      }

      error = null;
    } else {
      error = result.error ?? "Có lỗi xảy ra!";
    }

    isLoading = false;
    notifyListeners();
  }

  Future<Result<bool>> editTime(AttendanceHistory history, TimeOfDay checkinTime, TimeOfDay checkoutTime, String reason) async {

    var params = {
      'checkinTimeEdit': '${history.displayFullDate} ${checkinTime.asString}',
      'checkoutTimeEdit': '${history.displayFullDate} ${checkoutTime.asString}',
      'reason': reason,
      'sendApproveReq': true
    };

    isLoading = true;
    notifyListeners();

    final result = await networkService.editTime(params);

    if (result.isSuccess) {
      var oldHistoryItem = attendanceHistories.firstWhere((element) => element == history);
      oldHistoryItem.setRequestEditTimePending(checkinTime, checkoutTime);
    }

    isLoading = false;
    notifyListeners();

    return result;
  }

}