import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../services/action.dart';
import '../../../services/global.dart';
import '../../../utils/button_full_width.dart';
import '../../../utils/notification_bar.dart';
import '../../../utils/take_image.dart';

class AcceptDelivery extends StatefulWidget {
  final Map content;

  const AcceptDelivery({
    super.key,
    required this.content,
  });

  @override
  State<AcceptDelivery> createState() => _AcceptDeliveryState();
}

class _AcceptDeliveryState extends State<AcceptDelivery> {
  final _formKey = GlobalKey<FormState>();
  final _receiver = TextEditingController();
  Map selectData = {};
  String photoEncode = '';
  String photo = '';

  void validation() {
    if (_formKey.currentState!.validate()) {
      GlobalConfig.unfocus(context);
      if (photo == '') {
        NotificationBar.toastr('Gambar Pengiriman harus diisi', 'error');
      } else {
        showConfirmation(context);
      }
    }
  }

  void postSave(context) async {
    EasyLoading.show(status: 'Loading...');
    try {
      Map data = await ActionMethod.postNoAuth(
        'Surat_jalan/change_status',
        {
          'status_kirim': '1',
          'penerima': _receiver.text,
          'foto_bukti': photoEncode,
          'id': widget.content['id']
        },
      );

      if (data['statusCode'] == 200) {
        NotificationBar.toastr(data['message'], 'success');
        Navigator.pop(context);
        Navigator.pop(context, {
          'status': 'success',
          'status_transaction': 'Terkirim',
          'penerima': _receiver.text
        });
        EasyLoading.dismiss();
      } else {
        NotificationBar.toastr(data['message'], 'error');
      }
    } catch (e) {
      NotificationBar.toastr('Internal Server Error', 'error');
    }

    EasyLoading.dismiss();
  }

  void settingModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => {
                  Navigator.pop(context),
                  TakeImage.imageSelector(context, "gallery").then((value) {
                    if (value != null) {
                      var split = value.split(',');
                      setState(() {
                        photoEncode = value;
                        photo = split[1];
                      });
                    }
                  }),
                },
                icon: const Icon(Icons.image),
                label: const Text('Galeri'),
              ),
              const SizedBox(width: 20.0),
              ElevatedButton.icon(
                onPressed: () => {
                  Navigator.pop(context),
                  TakeImage.imageSelector(context, "camera").then((value) {
                    if (value != null) {
                      setState(() {
                        var split = value.split(',');
                        setState(() {
                          photoEncode = value;
                          photo = split[1];
                        });
                      });
                    }
                  }),
                },
                icon: const Icon(Icons.camera),
                label: const Text('Kamera'),
              )
            ],
          ),
        );
      },
    );
  }

  void clearImage() {
    setState(() {
      photoEncode = '';
      photo = '';
    });
  }

  void showConfirmation(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Apakah kamu yakin?"),
          content: const Text('Kamu akan melanjutkan proses ini!'),
          actions: <Widget>[
            TextButton(
              onPressed: () => postSave(context),
              style: TextButton.styleFrom(
                backgroundColor: GlobalConfig.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              child: const Text(
                'Ya',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              child: const Text(
                'Tidak',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
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
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lengkapi data untuk menyelesaikan pengiriman',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Masukkan nama penerima',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextFormField(
                    controller: _receiver,
                    autofocus: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.4),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: "Penerima",
                    ),
                    validator: receiverValidator,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.center,
                    child: photo == ''
                        ? Image.asset('images/blank.png', width: 300)
                        : Image.memory(base64Decode(photo), height: 300),
                  ),
                  const SizedBox(height: 20),
                  if (photo != '')
                    ButtonFullWidth(
                      label: 'Hapus File',
                      action: () => clearImage(),
                      color: Colors.white,
                      background: false,
                    )
                  else
                    ButtonFullWidth(
                      label: 'Ambil Gambar +',
                      action: () => settingModalBottomSheet(context),
                      color: Colors.white,
                      background: false,
                    ),
                  const SizedBox(height: 20),
                  ButtonFullWidth(
                    label: 'Simpan',
                    color: Colors.white,
                    background: true,
                    action: () => validation(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? receiverValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Penerima harus diisi';
    }
    return null;
  }
}
