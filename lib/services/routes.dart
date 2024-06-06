import 'package:flutter/material.dart';
import 'package:impact_driver/utils/show_preview_image.dart';
import '../layouts/pages/auth/login.dart';
import '../layouts/pages/delivery/accept_delivery.dart';
import '../layouts/pages/delivery/detail_transaction.dart';
import '../layouts/pages/tabs.dart';
import '../layouts/splashscreen.dart';

class AppRoutes {
  static var route = {
    '/': (context) => const Splashscreen(),
    '/login': (context) => const Login(),
    '/tabs': (context) => const Tabs(),
    '/detail-transaction': (context) => DetailTransaction(
        content: ModalRoute.of(context)?.settings.arguments as Map),
    '/accept-delivery': (context) => AcceptDelivery(
        content: ModalRoute.of(context)?.settings.arguments as Map),
    '/preview-image': (context) => ShowPreviewImage(
        content: ModalRoute.of(context)?.settings.arguments as Map),
  };
}
