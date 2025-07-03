import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:widget_zoom/widget_zoom.dart';

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
  List photos = [];

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

          if (selectData['surat_jalan']['foto_bukti'] != '' &&
              selectData['surat_jalan']['foto_bukti'] != null) {
            photos = selectData['surat_jalan']['foto_bukti'].split(',');
            // for (var i = 0; i < photos.length; i++) {
            //   print(photos[i].trim());
            // }
            // print(photos.length);
          }
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
      if (value != null) {
        getData();
      }
    });
  }

  void showPreviewImage(img, images, index) {
    Navigator.pushNamed(
      context,
      '/preview-image',
      arguments: {
        'img': img,
        'type': 'link',
        'images': images,
        'initialIndex': index
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pengiriman'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: selectData.isNotEmpty
              ? Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.content['title'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(DateFormat(' d MMMM y', "id_ID").format(
                              DateTime.parse(
                                  selectData['surat_jalan']['tanggal']))),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectData['customer']['nama'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: selectData['surat_jalan'] != null
                                    ? statusDelivery[selectData['surat_jalan']
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
                        ],
                      ),
                      if (selectData['customer']['alamat'] != '')
                        Text(
                          selectData['customer']['alamat'],
                          style: const TextStyle(fontSize: 15),
                        ),
                      // const SizedBox(height: 10),
                      if (selectData['customer']['no_hp'] != '')
                        Text(
                          selectData['customer']['no_hp'],
                          style: const TextStyle(fontSize: 15),
                        ),
                      if (selectData['surat_jalan']['keterangan'] != '')
                        Text(
                          selectData['surat_jalan']['keterangan'],
                          style: const TextStyle(fontSize: 15),
                        ),
                      const SizedBox(height: 10),
                      const Divider(),
                      if (selectData['surat_jalan']['penerima'] != null &&
                          selectData['surat_jalan']['penerima'] != '')
                        Row(
                          children: [
                            const SizedBox(
                              width: 80,
                              child: Text(
                                'Penerima',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 10, child: Text(':')),
                            Expanded(
                              child:
                                  Text(selectData['surat_jalan']['penerima']),
                            )
                          ],
                        ),
                      if (selectData['surat_jalan']['note'] != null) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 80,
                              child: Text(
                                'Catatan',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 10, child: Text(':')),
                            Expanded(
                              child: Text(selectData['surat_jalan']['note']),
                            )
                          ],
                        )
                      ],
                      const SizedBox(height: 10),
                      if (photos.isNotEmpty)
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ),
                          ),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              for (var i = 0; i < photos.length; i++)
                                Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    InkWell(
                                      onTap: () => showPreviewImage(
                                          photos[i].trim(), photos, i),
                                      child: Container(
                                        margin: const EdgeInsets.all(5),
                                        child: Image.network(
                                          photos[i].trim(),
                                          width: 200,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
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
                          'Detail Barang',
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['kode_produk'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(item['nama_produk'])
                                  ],
                                ),
                              ),
                              Text(
                                item['qty_kirim'].toString(),
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
