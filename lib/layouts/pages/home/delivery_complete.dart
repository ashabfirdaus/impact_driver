import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

import '../../../services/action.dart';
import '../../../services/global.dart';
import '../../../utils/list_transaction.dart';
import '../../../utils/not_found.dart';
import '../../../utils/notification_bar.dart';

class DeliveryComplete extends StatefulWidget {
  // final TextEditingController searchText;
  const DeliveryComplete({
    super.key,
    // required this.searchText,
  });

  @override
  State<DeliveryComplete> createState() => _DeliveryCompleteState();
}

class _DeliveryCompleteState extends State<DeliveryComplete> {
  List listData = [];
  final ScrollController _scrollController = ScrollController();
  Map loadMore = {'current_page': 1, 'last_page': 1, 'limit': 12};
  Timer? timer;
  Icon customIcon = const Icon(Icons.search);
  final FocusNode searchFocusNode = FocusNode();
  final searchText = TextEditingController();
  Widget customSearchBar = const Text('Terkirim');
  String tempDate = '';
  final _date = TextEditingController();
  DateTime datetime = DateTime.now();

  @override
  void initState() {
    getData();
    super.initState();

    searchText.addListener(detectKeyword);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels.toString() ==
          _scrollController.position.maxScrollExtent.toString()) {
        if (loadMore['current_page'] < loadMore['last_page']) {
          getData();
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
        loadMore['current_page'] = 1;
      });

      await getData();
    });
  }

  Future<void> getData() async {
    EasyLoading.show(status: 'Loading...');
    try {
      Map data = await ActionMethod.getNoAuth(
        'Surat_jalan/driverData',
        {
          "num_page": loadMore["limit"].toString(),
          "page": loadMore["current_page"].toString(),
          "keyword": searchText.text.toString(),
          "status_kirim": '1',
          "karyawan_id": GlobalConfig.user['anggota_id'],
          'tanggal': tempDate
        },
      );

      if (data['statusCode'] == 200) {
        setStateIfMounted(() {
          if (loadMore['current_page'] == 1) {
            listData = data['values'];
          } else {
            listData.addAll(data['values']);
          }

          loadMore = {
            'current_page': loadMore['current_page'] + 1,
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

  Future<void> refreshGetData() async {
    setStateIfMounted(() {
      loadMore = {'current_page': 1, 'last_page': 0, 'limit': 12};
    });

    await getData();
    return;
  }

  void detailTransaction(object, index) {
    Navigator.pushNamed(context, '/detail-transaction', arguments: {
      'id': object['surat_jalan']['id'].toString(),
      'title': object['surat_jalan']['kode'],
    }).then((value) async {
      if (value == null) {
        // print('kosong');
      }
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
        customSearchBar = const Text('Terkirim');
        setState(() {
          searchText.text = '';
        });
      }
    });
  }

  void showDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: datetime,
        firstDate: DateTime(2024),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2100));
    if (pickedDate != null) {
      String formattedDate =
          DateFormat('EEEE, d MMMM y', "id_ID").format(pickedDate);
      setState(() {
        datetime = pickedDate;
        _date.text = formattedDate;
        tempDate = DateFormat('y-M-d', "id_ID").format(pickedDate).toString();

        loadMore["current_page"] = 1;
      });
    } else {
      setState(() {
        _date.text = '';
        tempDate = '';
        loadMore["current_page"] = 1;
      });
    }

    getData();
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
              onRefresh: refreshGetData,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      controller: _date,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.calendar_today),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.4),
                        labelText: 'Tanggal',
                      ),
                      readOnly: true,
                      // validator: dateValidator,
                      onTap: () => showDate(),
                    ),
                  ),
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
