import 'package:flutter/material.dart';

import '../../services/global.dart';
import '../../utils/tabbutton.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    GlobalConfig.unfocus(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: [
          for (final tabItem in TabNavigation.items) tabItem.page,
        ],
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: GlobalConfig.primaryColor, width: 1.0),
          ),
        ),
        child: TabBar(
          indicatorColor: GlobalConfig.primaryColor,
          labelColor: Colors.black,
          controller: _tabController,
          tabs: <Widget>[
            for (var i = 0; i < TabNavigation.items.length; i++)
              Tab(
                icon: _tabController.index == i
                    ? TabNavigation.items[i].iconActive
                    : TabNavigation.items[i].iconDefault,
                text: TabNavigation.items[i].title,
                iconMargin: const EdgeInsets.all(2),
              ),
          ],
        ),
      ),
    );
  }
}
