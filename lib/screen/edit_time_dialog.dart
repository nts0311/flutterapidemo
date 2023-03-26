import 'package:flutter/material.dart';
import 'package:flutterapidemo/ext/extensions.dart';
import 'package:flutterapidemo/model/attendance_history.dart';

class EditTimeDialog extends StatefulWidget {

  final Function(TimeOfDay checkin, TimeOfDay checkout, String reason) onRegisterPressed;

  final AttendanceHistory history;
  late TimeOfDay checkinTime;
  late TimeOfDay checkoutTime;


  EditTimeDialog({Key? key, required this.history, required this.onRegisterPressed}) : super(key: key) {
    checkinTime = history.checkin?.toTimeOfDay ?? const TimeOfDay(hour: 8, minute: 0);
    checkoutTime = history.checkout?.toTimeOfDay ?? const TimeOfDay(hour: 17, minute: 30);
  }

  @override
  State<EditTimeDialog> createState() => _EditTimeDialogState();
}

class _EditTimeDialogState extends State<EditTimeDialog> {
  final _formkey = GlobalKey<FormState>();

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Đăng ký điều chỉnh'),
      content: Form(
        key: _formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Ngày: ${widget.history.displayFullDate}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => displayChooseTimeDialog(widget.checkinTime),
              child: Row(
                children: [
                  const Text('Thời gian checkin:'),
                  const SizedBox(width: 4),
                  Text(widget.checkinTime.format(context), style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => displayChooseTimeDialog(widget.checkoutTime),
              child: Row(
                children: [
                  const Text('Thời gian checkout:'),
                  const SizedBox(width: 4),
                  Text(widget.checkoutTime.format(context), style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text('Lý do:'),
            TextFormField(
              controller: _textController,
              validator: (value) {
                if (value == null || value.isEmpty)
                  return "Bạn phải nhập lý do điều chỉnh";

                return null;
              },
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Huỷ bỏ'),
        ),
        TextButton(
          onPressed: () {
            if (_formkey.currentState!.validate()) {
              Navigator.of(context).pop();
              widget.onRegisterPressed.call(widget.checkinTime, widget.checkoutTime, _textController.text);
            }
          },
          child: const Text('Đăng ký'),
        )
      ],
    );
  }

  void displayChooseTimeDialog(TimeOfDay which) async {

    final helpText = (which == widget.checkinTime) ? 'Chọn giờ checkin' : 'Chọn giờ checkout';

    final selectedTime = await showTimePicker(
        context: context,
        initialTime: which,
        helpText: helpText,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        }
    );

    setState(() {
      if (selectedTime != null) {
        if (which == widget.checkinTime) {
          widget.checkinTime = selectedTime;
        } else {
          widget.checkoutTime = selectedTime;
        }
      }
    });
  }
}
//https://voz.vn/t/lay-vo-dam-kho-qua-cac-bac-a.741514/