import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../services/action.dart';
import '../../../services/global.dart';
import '../../../utils/button_full_width.dart';
import '../../../utils/notification_bar.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final storage = const FlutterSecureStorage();
  bool isShowPassword = true;
  late FocusNode focusNodeUsername;
  Map data = {
    'access_token': 'asd',
    'statusCode': 200,
    'message': 'Berhasil Login',
    'user': {'username': ''},
  };

  @override
  void initState() {
    super.initState();
    focusNodeUsername = FocusNode();
  }

  void validation() {
    if (_formKey.currentState!.validate()) {
      GlobalConfig.unfocus(context);
      postLogin(context);
    }
  }

  void postLogin(context) async {
    EasyLoading.show(status: 'Loading...');
    try {
      Map data = await ActionMethod.postNoAuth(
        'Identity/userLogin',
        {
          'identity': _username.text,
          'password': _password.text,
        },
      );

      if (data['statusCode'] == 200) {
        // data['user']['username'] = _username.text;
        // GlobalConfig.token = data['access_token'];
        GlobalConfig.user = data['values']['user'];

        // await storage.write(key: 'token', value: data['access_token']);
        await storage.write(
            key: 'user', value: jsonEncode(data['values']['user']));

        NotificationBar.toastr(data['message'], 'success');
        EasyLoading.dismiss();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/tabs', (route) => false);
      } else {
        NotificationBar.toastr(data['message'], 'error');
      }
    } catch (e) {
      NotificationBar.toastr('Internal Server Error', 'error');
    }

    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => GlobalConfig.unfocus(context),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('images/logo.png', width: 300),
                    const SizedBox(height: 20.0),
                    const Text(
                      'Selamat datang, silahkan masukan akun anda',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _username,
                      autofocus: true,
                      focusNode: focusNodeUsername,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: "Username",
                      ),
                      validator: usernameValidator,
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      obscureText: isShowPassword,
                      controller: _password,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: 'Password',
                      ),
                      validator: passwordValidator,
                    ),
                    const SizedBox(height: 10),
                    ButtonFullWidth(
                      label: 'Masuk',
                      action: () => validation(),
                      background: true,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? usernameValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Email atau nomor telepon harus diisi';
    }
    return null;
  }

  String? passwordValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Password harus diisi';
    }
    return null;
  }
}
