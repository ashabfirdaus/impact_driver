import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../services/action.dart';
import '../../../services/global.dart';
import '../../../utils/button_full_width.dart';
import '../../../utils/notification_bar.dart';

class DetailTransaction extends StatefulWidget {
  final Map content;

  const DetailTransaction({
    super.key,
    required this.content,
  });

  @override
  State<DetailTransaction> createState() => _DetailTransactionState();
}

class _DetailTransactionState extends State<DetailTransaction> {
  Map selectData = {};
  bool isReceiver = false;
  Map statusDelivery = {
    '0': {'status': 'Belum Dikirim', 'color': Colors.red},
    '1': {'status': 'Terkirim', 'color': Colors.cyan}
  };

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    EasyLoading.show(status: 'Loading...');
    try {
      Map data = await ActionMethod.postNoAuth(
          'Surat_jalan/detail', {'id': widget.content['id']});
      if (data['statusCode'] == 200) {
        setState(() {
          selectData = data['values'];
        });
      } else {
        NotificationBar.toastr(data['message'], 'error');
      }
    } catch (e) {
      NotificationBar.toastr('Internal Server Error', 'error');
    }

    EasyLoading.dismiss();
  }

  void acceptDelivery() {
    Navigator.pushNamed(context, '/accept-delivery', arguments: {
      'id': selectData['surat_jalan']['id'].toString(),
      'title': selectData['surat_jalan']['kode'],
    }).then((value) async {
      if (value == null) {
        // print('kosong');
      } else {
        if (value is Map) {
          getData();
        }
      }
    });
  }

  void previewBuktiFoto() {
    Navigator.pushNamed(context, '/preview-image',
        arguments: {'image_url': selectData['surat_jalan']['foto_bukti']});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.content['title']),
        backgroundColor: GlobalConfig.primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: selectData.isNotEmpty
              ? Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectData['customer']['nama'],
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                selectData['customer']['alamat'],
                                style: const TextStyle(fontSize: 15),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                selectData['customer']['no_hp'],
                                style: const TextStyle(fontSize: 15),
                              ),
                              if (selectData['surat_jalan']['penerima'] !=
                                  null) ...[
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 60,
                                      child: Text(
                                        'Penerima',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(width: 10, child: Text(':')),
                                    Expanded(
                                      child: Text(selectData['surat_jalan']
                                          ['penerima']),
                                    )
                                  ],
                                )
                              ],
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 120,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: selectData['surat_jalan'] != null
                                        ? statusDelivery[
                                            selectData['surat_jalan']
                                                ['status_kirim']]['color']
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  selectData['surat_jalan'] != null
                                      ? statusDelivery[selectData['surat_jalan']
                                          ['status_kirim']]['status']
                                      : '',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              if (selectData['surat_jalan']['foto_bukti'] !=
                                      '' &&
                                  selectData['surat_jalan']['foto_bukti'] !=
                                      null) ...[
                                const SizedBox(height: 20),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextButton.icon(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.black54,
                                    ),
                                    icon: const Icon(Icons.image),
                                    label: const Text("Foto Bukti"),
                                    onPressed: () => previewBuktiFoto(),
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                      ]),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: GlobalConfig.primaryColor,
                              width: 2,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Barang - barang yang dikirim',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      for (var item in selectData['detail_produk'])
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade200,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                item['nama_produk'],
                                style: const TextStyle(fontSize: 15),
                              )),
                              Text(
                                item['qty'].toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 20),
                      if (selectData['surat_jalan']['status_kirim'] == '0')
                        ButtonFullWidth(
                          label: 'Selesaikan',
                          color: Colors.white,
                          background: true,
                          action: () => acceptDelivery(),
                        )
                    ],
                  ),
                )
              : const Text(''),
        ),
      ),
    );
  }
}
