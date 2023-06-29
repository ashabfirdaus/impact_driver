import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../layouts/pages/home/index.dart';
import '../layouts/pages/home/profile.dart';
import '../services/global.dart';

class TabNavigation {
  final Widget page;
  final String title;
  final SvgPicture iconDefault;
  final SvgPicture iconActive;

  TabNavigation({
    required this.page,
    required this.title,
    required this.iconDefault,
    required this.iconActive,
  });

  static List<TabNavigation> get items => [
        TabNavigation(
          page: const Home(),
          iconDefault: SvgPicture.asset(
            'images/home.svg',
            width: 30.0,
            color: Colors.grey[600],
          ),
          iconActive: SvgPicture.asset(
            'images/home.svg',
            width: 30.0,
            color: GlobalConfig.primaryColor,
          ),
          title: "Beranda",
        ),
        TabNavigation(
          page: const Profile(),
          iconDefault: SvgPicture.asset(
            'images/profile.svg',
            width: 30.0,
            color: Colors.grey[600],
          ),
          iconActive: SvgPicture.asset(
            'images/profile.svg',
            width: 30.0,
            color: GlobalConfig.primaryColor,
          ),
          title: "Akun",
        ),
      ];
}
