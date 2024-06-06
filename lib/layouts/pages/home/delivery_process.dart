import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../services/action.dart';
import '../../../services/global.dart';
import '../../../utils/list_transaction.dart';
import '../../../utils/not_found.dart';
import '../../../utils/notification_bar.dart';

class DeliveryProcess extends StatefulWidget {
  const DeliveryProcess({
    super.key,
  });

  @override
  State<DeliveryProcess> createState() => _DeliveryProcessState();
}

class _DeliveryProcessState extends State<DeliveryProcess> {
  List listData = [];
  final ScrollController _scrollController = ScrollController();
  Map loadMorePro = {'current_page': 1, 'last_page': 1, 'limit': 12};
  Timer? timer;
  Icon customIcon = const Icon(Icons.search);
  final FocusNode searchFocusNode = FocusNode();
  final searchText = TextEditingController();
  Widget customSearchBar = const Text('Pengiriman');

  @override
  void initState() {
    getDataPro();
    super.initState();

    searchText.addListener(detectKeyword);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels.toString() ==
          _scrollController.position.maxScrollExtent.toString()) {
        if (loadMorePro['current_page'] < loadMorePro['last_page']) {
          getDataPro();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  void detectKeyword() {
    if (timer != null) {
      timer?.cancel();
      timer = null;
    }

    timer = Timer(const Duration(seconds: 1), () async {
      setStateIfMounted(() {
        loadMorePro['current_page'] = 1;
      });

      await getDataPro();
    });
  }

  Future<void> getDataPro() async {
    EasyLoading.show(status: 'Loading...');
    try {
      Map data = await ActionMethod.getNoAuth(
        'Surat_jalan/driverData',
        {
          "num_page": loadMorePro["limit"].toString(),
          "page": loadMorePro["current_page"].toString(),
          "keyword": searchText.text.toString(),
          "status_kirim": '0',
          "karyawan_id": GlobalConfig.user['anggota_id']
        },
      );

      if (data['statusCode'] == 200) {
        setStateIfMounted(() {
          if (loadMorePro['current_page'] == 1) {
            listData = data['values'];
          } else {
            listData.addAll(data['values']);
          }

          loadMorePro = {
            'current_page': loadMorePro['current_page'] + 1,
            'last_page': data['max_page'],
            'limit': 12
          };
        });
      } else {
        setStateIfMounted(() {
          listData = [];
        });
        NotificationBar.toastr(data['message'], 'error');
      }
    } catch (e) {
      NotificationBar.toastr('Internal Server Error', 'error');
    }

    EasyLoading.dismiss();
  }

  Future<void> refreshGetDataPro() async {
    setStateIfMounted(() {
      loadMorePro = {'current_page': 1, 'last_page': 0, 'limit': 12};
    });

    await getDataPro();
    return;
  }

  void detailTransaction(object, index) {
    Navigator.pushNamed(context, '/detail-transaction', arguments: {
      'id': object['surat_jalan']['id'].toString(),
      'title': object['surat_jalan']['kode'],
    }).then((value) async {
      refreshGetDataPro();
    });
  }

  void searchActive() {
    setState(() {
      if (customIcon.icon == Icons.search) {
        searchFocusNode.requestFocus();
        customIcon = const Icon(Icons.cancel);
        customSearchBar = ListTile(
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
        setState(() {
          searchText.text = '';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customSearchBar,
        actions: [
          IconButton(
            onPressed: searchActive,
            icon: customIcon,
          )
        ],
      ),
      body: GestureDetector(
        onTap: () => GlobalConfig.unfocus(context),
        child: Scaffold(
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: refreshGetDataPro,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  if (listData.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _scrollController,
                        itemCount: listData.isEmpty ? 0 : listData.length,
                        itemBuilder: (BuildContext context, int index) {
                          final data = listData[index];
                          return ListTransaction(
                            content: data,
                            action: () => detailTransaction(data, index),
                          );
                        },
                      ),
                    )
                  else
                    const Expanded(
                      child: NotFound(
                        label: 'Data tidak ditemukan',
                        size: 'normal',
                        isButton: false,
                      ),
                    ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
