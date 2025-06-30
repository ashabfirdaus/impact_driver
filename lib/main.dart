import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:impact_driver_v2/services/global.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:impact_driver_v2/services/routes.dart';

void main() async {
  await initializeDateFormatting('id_ID', null);
  runApp(const MainApp());
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

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Impact',
      theme: ThemeData(
        primaryColor: GlobalConfig.primaryColor,
        appBarTheme: AppBarTheme(
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
          centerTitle: true,
          backgroundColor: GlobalConfig.primaryColor,
        ),
      ),
      initialRoute: '/',
      routes: AppRoutes.route,
      builder: EasyLoading.init(),
    );
  }
}
