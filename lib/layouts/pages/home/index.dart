import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../services/action.dart';
import '../../../services/global.dart';
import '../../../utils/button_full_width.dart';
import '../../../utils/list_transaction.dart';
import '../../../utils/not_found.dart';
import '../../../utils/notification_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  List listData = [];
  final ScrollController _scrollController = ScrollController();
  Map loadMore = {'current_page': 1, 'last_page': 1, 'limit': 7};
  String statusActive = '0';
  late Timer t;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    getData();
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels.toString() ==
          _scrollController.position.maxScrollExtent.toString()) {
        if (loadMore['current_page'] < loadMore['last_page']) {
          getData();
        }
      }
    });

    t = Timer(const Duration(milliseconds: 500), () {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> getData() async {
    EasyLoading.show(status: 'Loading...');
    try {
      Map data = await ActionMethod.postNoAuth(
        'Surat_jalan/data',
        {
          "status": "0",
          "status_kirim": statusActive,
          "num_page": loadMore["limit"].toString(),
          "page": loadMore["current_page"].toString()
        },
      );

      if (data['statusCode'] == 200) {
        setState(() {
          if (loadMore['current_page'] == 1) {
            listData = data['values'];
          } else {
            listData.addAll(data['values']);
          }

          loadMore = {
            'current_page': loadMore['current_page'] + 1,
            'last_page': data['max_page'],
            'limit': 7
          };
        });
      } else {
        setState(() {
          listData = [];
        });
        NotificationBar.toastr(data['message'], 'error');
      }
    } catch (e) {
      NotificationBar.toastr('Internal Server Error', 'error');
    }

    EasyLoading.dismiss();
  }

  Future<void> refreshGetData() async {
    setState(() {
      loadMore = {'current_page': 1, 'last_page': 0, 'limit': 7};
    });

    await getData();
    return;
  }

  void changePageActive(string) {
    GlobalConfig.unfocus(context);
    setState(() {
      statusActive = string;
    });
    refreshGetData();
  }

  void detailTransaction(object, index) {
    Navigator.pushNamed(context, '/detail-transaction', arguments: {
      'id': object['surat_jalan']['id'].toString(),
      'title': object['surat_jalan']['kode'],
    }).then((value) async {
      if (value == null) {
        // print('kosong');
      }
      // else {
      //   if (value is Map) {
      //     Map res = value;
      //     setState(() {
      //       listData[index]['approval'] = res['data']['approval'];
      //       listData[index]['payment_status'] = res['data']['payment_status'];
      //       listData[index]['total_payment'] = res['data']['total_payment'];
      //     });
      //   }
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refreshGetData,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: GlobalConfig.primaryColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ButtonFullWidth(
                        label: 'Proses Kirim',
                        color: Colors.white,
                        action: () => changePageActive('0'),
                        background: statusActive == '0' ? false : true,
                      ),
                    ),
                    Expanded(
                      child: ButtonFullWidth(
                        label: 'Selesai',
                        color: Colors.white,
                        action: () => changePageActive('1'),
                        background: statusActive == '1' ? false : true,
                      ),
                    ),
                  ],
                ),
              ),
              if (listData.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    itemCount: listData.isEmpty ? 0 : listData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTransaction(
                        content: listData[index],
                        action: () => detailTransaction(listData[index], index),
                      );
                    },
                  ),
                )
              else
                const Expanded(
                  child: NotFound(
                    label: 'Belum ada transaksi',
                    size: 'normal',
                    isButton: false,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
