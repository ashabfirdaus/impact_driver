import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../services/global.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    checkAuth(context);
  }

  void checkAuth(context) async {
    try {
      Map<String, String> all = await storage.readAll();
      if (all['user'] == null) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        // GlobalConfig.token = all['token']!;
        GlobalConfig.user = jsonDecode(all['user']!);
        Navigator.pushReplacementNamed(context, '/tabs');
      }
    } catch (e) {
      await storage.deleteAll();
      checkAuth(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          alignment: Alignment.center,
          child: Image.asset(
            'images/loading.gif',
            width: 200,
          ),
        ),
      ),
    );
  }
}
