import 'package:flutter/widgets.dart';

class GlobalConfig {
  static String baseUrl = 'api.impactfurniture.id';
  static String pathUrl = '/index.php/api/';
  static String typeUrl = 'prod';
  static Color primaryColor = const Color.fromARGB(255, 231, 166, 2);
  static String token = '';
  static Map user = {};
  // C:\Users\Rudi\AppData\Local\Android\Sdk\platform-tools
  // typeUrl => ['prod','local']
  // baseUrl => ['app.magicloundry.com','10.10.11.120:8080/magic_laundry/public']

  static unfocus(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}

//build with version
// android: flutter build appbundle --build-name=[version] --build-number=[code]
// ios: flutter build ipa --build-name=[version] --build-number=[code]
// flutter version 3.10.5