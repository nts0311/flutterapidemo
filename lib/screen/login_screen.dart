
import 'package:flutter/material.dart';
import 'package:flutterapidemo/ext/extensions.dart';
import 'package:flutterapidemo/screen/attendance_screen.dart';
import 'package:flutterapidemo/viewmodel/login_viewmodel.dart';
import 'package:provider/provider.dart';

import '../viewmodel/attendance_viewmodel.dart';
import '../viewmodel/home_viewmodel.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();

  static void toLoginScreen(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) {
          return ChangeNotifierProvider(
              create: (context) => LoginViewModel(context: context),
              child: const LoginScreen()
          );
        })
    );
  }
}

class _LoginScreenState extends State<LoginScreen> {

  final usernameController = TextEditingController(text: 'sonnt@biplus.com.vn');
  final passwordController = TextEditingController(text: 'Thaison123456@@');

  final _formkey = GlobalKey<FormState>();

  LoginViewModel get viewModel => Provider.of<LoginViewModel>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<LoginViewModel>(builder: (context, viewModel, child) => buildScreen())
    );
  }

  Widget buildScreen() { 
    return Stack(
      children: [
        viewModel.isLoading ? buildLoading() : const SizedBox(),
        buildLoginForm()
      ],
    );
  }
  
  Widget buildLoading() {
    return Container(
      color: Colors.grey.withOpacity(0.5),
      child: const CircularProgressIndicator().center(),
    );
  }
  
  Widget buildLoginForm() {
    return Form(
      key: _formkey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Đăng nhập', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextFormField(
            controller: usernameController,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Bạn phải nhập email';

              final bool emailValid =
              RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value);

              if (!emailValid) return 'email không đúng đinh dạng';

              return null;
            },
            decoration: const InputDecoration(
                hintText: "Tên đăng nhập",
                icon: Icon(Icons.person)
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: passwordController,
            validator: (value) {
              return (value == null || value.isEmpty) ? 'Bạn phải nhập mật khẩu' : null;
            },
            obscureText: true,
            decoration: const InputDecoration(
              hintText: "Mật khẩu",
              icon: Icon(Icons.password),
            ),
          ),
          const SizedBox(height: 16),
          viewModel.isLoginError ? Text(viewModel.error ?? "", style: const TextStyle(color: Colors.red)) : const SizedBox(),
          const SizedBox(height: 16),
          ElevatedButton(

            onPressed: () {
              onLoginTapped();
            },
            child: const Text('Đăng nhập'),
          )
        ],
      ).center()
          .padding(const EdgeInsets.symmetric(horizontal: 16)),
    );
  }

  void onLoginTapped() async {
    if (_formkey.currentState!.validate()) {
      performLogin();
    } else {

    }
  }

  void performLogin() async {
    final user = await viewModel.login(usernameController.text, passwordController.text);

    if (user == null) return;

    if (!context.mounted) return;

    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) => HomeViewModel(),
          child: const HomeScreen(),
        )
    ));
  }

}

