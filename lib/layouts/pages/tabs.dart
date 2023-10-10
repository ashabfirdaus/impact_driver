import 'package:flutter/material.dart';
import 'package:impact_driver/layouts/pages/home/delivery_complete.dart';
import 'package:impact_driver/layouts/pages/home/delivery_process.dart';
import 'package:impact_driver/layouts/pages/home/profile.dart';

import '../../services/global.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  static final List<Widget> _pages = <Widget>[
    const DeliveryProcess(),
    const DeliveryComplete(),
    const Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex), //New
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.delivery_dining),
              label: 'Pengiriman',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.handshake),
              label: 'Terkirim',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2),
              label: 'Akun',
            ),
          ],
          currentIndex: _selectedIndex, //New
          onTap: _onItemTapped,
          selectedItemColor: GlobalConfig.primaryColor),
    );
  }
}
