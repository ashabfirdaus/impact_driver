import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ShowPreviewImage extends StatelessWidget {
  final Map content;
  const ShowPreviewImage({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: PhotoView(
        imageProvider: MemoryImage(content['img']),
        minScale: PhotoViewComputedScale.contained * 0.8,
        maxScale: PhotoViewComputedScale.covered * 1.8,
        initialScale: PhotoViewComputedScale.contained,
      ),
    );
  }
}
