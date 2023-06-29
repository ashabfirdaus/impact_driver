import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:impact_driver/services/global.dart';
import 'package:impact_driver/services/routes.dart';

void main() {
  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 60
    ..radius = 20
    ..backgroundColor = Colors.grey.shade200
    ..maskColor = GlobalConfig.primaryColor
    ..indicatorColor = GlobalConfig.primaryColor
    ..textColor = GlobalConfig.primaryColor
    ..userInteractions = false
    ..dismissOnTap = false
    ..boxShadow = <BoxShadow>[]
    ..indicatorType = EasyLoadingIndicatorType.ring;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Impact',
      theme: ThemeData(
        primaryColor: GlobalConfig.primaryColor,
      ),
      initialRoute: '/',
      routes: AppRoutes.route,
      builder: EasyLoading.init(),
    );
  }
}
