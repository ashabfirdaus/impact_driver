import 'package:flutter/material.dart';
import 'package:impact_driver/layouts/pages/home/delivery_complete.dart';
import 'package:impact_driver/layouts/pages/home/delivery_process.dart';
import '../../../services/global.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Pengiriman');
  bool showBackButton = true;
  final searchText = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchText.dispose();
    super.dispose();
  }

  void searchActive() {
    setState(() {
      if (customIcon.icon == Icons.search) {
        searchFocusNode.requestFocus();
        showBackButton = false;
        customIcon = const Icon(Icons.cancel);
        customSearchBar = ListTile(
          leading: const Icon(
            Icons.search,
            color: Colors.white,
            // size: 28,
          ),
          title: TextField(
            focusNode: searchFocusNode,
            controller: searchText,
            decoration: const InputDecoration(
              hintText: 'Masukkan kata kunci ...',
              hintStyle: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
              border: InputBorder.none,
            ),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        );
      } else {
        customIcon = const Icon(Icons.search);
        searchFocusNode.unfocus();
        customSearchBar = const Text('Pengiriman');
        showBackButton = true;
        setState(() {
          searchText.text = '';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: customSearchBar,
          actions: [
            IconButton(
              onPressed: searchActive,
              icon: customIcon,
            )
          ],
          automaticallyImplyLeading: showBackButton,
          bottom: const TabBar(
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                child: Text(
                  'Proses Kirim',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Tab(
                child: Text(
                  'Selesai',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
          backgroundColor: GlobalConfig.primaryColor,
        ),
        body: const TabBarView(
          children: [
            DeliveryProcess(),
            DeliveryComplete(),
          ],
        ),
      ),
    );
  }
}
