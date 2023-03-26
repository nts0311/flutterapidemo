import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension WidgetUtils on Widget {
  Widget padding(EdgeInsets edgeInsets) {
    return Padding(padding: edgeInsets, child: this);
  }

  Widget center() {
    return Center(child: this);
  }
}

extension DateUtils on String {
  TimeOfDay get toTimeOfDay {
    DateTime dateTime = DateFormat("hh:mm:ss").parse(this);
    return TimeOfDay.fromDateTime(dateTime);
  }
}

extension TimeUtils on TimeOfDay {
  String get asString {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  String get asStringWithSecond {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:00';
  }
}