
import 'package:flutter/material.dart';
import 'package:flutterapidemo/model/attendance_history.dart';
import 'package:flutterapidemo/screen/edit_time_dialog.dart';
import 'package:flutterapidemo/viewmodel/attendance_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:flutterapidemo/ext/extensions.dart';

import '../viewmodel/login_viewmodel.dart';
import 'login_screen.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {

  AttendanceViewModel get viewModel => Provider.of<AttendanceViewModel>(context, listen: false);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,() async {
      await viewModel.getHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceViewModel>(builder: (context, viewModel, child) => buildScreen());
  }

  Widget buildScreen() {
    if (viewModel.error != null) {
      return Text(viewModel.error!).center();
    }

    return Stack(
      children: [
        ListView.separated(
          itemBuilder: (context, index) => buildItem(index),
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemCount: viewModel.attendanceHistories.length
        ),

        viewModel.isLoading ? const CircularProgressIndicator().center() : const SizedBox()
      ]
    ).padding(const EdgeInsets.symmetric(vertical: 8));
  }

  Widget buildItem(int index) {
    final item = viewModel.attendanceHistories[index];
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              item.isRequestEditTimePending ? SizedBox(width: 20, height: 20, child: Image.asset('images/waiting-approval.png')) : const SizedBox(),
              Text('Ngày ${item.displayDate}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
              IconButton(
                onPressed: () {
                  showEditTimeDialog(item);
                },
                icon: const Icon(Icons.edit_calendar_sharp, size: 20, color: Colors.grey),
              )
            ]
          ),
          const SizedBox(height: 8),
          Container(height: 1, color: Colors.grey.shade300),
          const SizedBox(height: 8),

          (item.checkin != null) ? Text('Giờ checkin: ${item.displayCheckinTime}', style: const TextStyle(fontSize: 18)) : const SizedBox(),
          const SizedBox(height: 8),
          (item.checkout != null) ? Text('Giờ checkout: ${item.displayCheckoutTime}', style: const TextStyle(fontSize: 18)) : const SizedBox(),

          const SizedBox(height: 16),

          (item.date?.day == DateTime.now().day) ? Row(
            children: [
              ElevatedButton(
                onPressed: item.hasCheckin ? null : () async {
                  viewModel.checkin();
                },
                child: const Text('Checkin')
              ),

              const SizedBox(width: 16),
              ElevatedButton(
                  onPressed: (item.hasCheckout || !item.hasCheckin ) ? null : () async {
                    viewModel.checkout();
                  },
                  child: const Text('Checkout'),
              )

            ]
          ) : const SizedBox()


        ]
      ).padding(const EdgeInsets.symmetric(horizontal: 8, vertical: 8))
    ).padding(const EdgeInsets.symmetric(horizontal: 16));
  }

  void showEditTimeDialog(AttendanceHistory historyItem) {
    showDialog(context: context, builder: (context) => EditTimeDialog(
      history: historyItem,
      onRegisterPressed: (checkinTime, checkoutTime, reason) async {
        final result = await viewModel.editTime(historyItem, checkinTime, checkoutTime, reason);

        if (!this.context.mounted) return;

        if (!result.isSuccess) {
          final snackBar = SnackBar(content: Text(result.error!));
          ScaffoldMessenger.of(this.context).showSnackBar(snackBar);
        }
      }
    ));
  }
}
