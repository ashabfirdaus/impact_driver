import 'package:flutter/material.dart';

import '../../../services/global.dart';

class PreviewImage extends StatefulWidget {
  final Map content;
  const PreviewImage({
    super.key,
    required this.content,
  });

  @override
  State<PreviewImage> createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foto Bukti Pengiriman'),
        backgroundColor: GlobalConfig.primaryColor,
      ),
      body: SafeArea(
        child: Image.network(
          widget.content['image_url'],
          fit: BoxFit.contain,
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.do_disturb_alt_outlined,
                    size: 100,
                    color: Colors.red,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Terdapat masalah saat mengambil data.',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
