import 'package:flutter/material.dart';
import 'package:flutterapidemo/screen/absent_management_screen.dart';
import 'package:flutterapidemo/viewmodel/home_viewmodel.dart';
import 'package:provider/provider.dart';

import '../viewmodel/attendance_viewmodel.dart';
import 'attendance_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedTab = 0;

  HomeViewModel get viewModel => Provider.of<HomeViewModel>(context, listen: false);

  final pages = [
    ChangeNotifierProvider(
      create: (context) => AttendanceViewModel(context: context),
      child: const AttendanceScreen()
    ),
    AbsentManagementScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('BiPower'),
            actions:[
              PopupMenuButton(
                onSelected: (item) => handleClick(item),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 0, child: Text('Logout')),
                ],
              ),
            ]
        ),
        body: pages[_selectedTab],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedTab,
          onTap: (index) => {
            setState(() {
              _selectedTab = index;
            })
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.library_add_check),
              label: 'Chấm công'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.work_history_rounded),
                label: 'Quản lý nghỉ'
            )
          ],
        )
    );
  }

  void handleClick(int item) async {
    switch (item) {
      case 0:
        final logoutSuccess = await viewModel.logout();
        if (logoutSuccess) {
          if (!context.mounted) return null;
          LoginScreen.toLoginScreen(context);
        }
        break;
      default:
        break;
    }
  }
}
