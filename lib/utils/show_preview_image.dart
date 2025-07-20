import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

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
        // body: PhotoView(
        //   imageProvider: content['type'] == 'base64'
        //       ? MemoryImage(content['img'])
        //       : NetworkImage(content['img']) as ImageProvider,
        //   minScale: PhotoViewComputedScale.contained * 0.8,
        //   maxScale: PhotoViewComputedScale.covered * 1.8,
        //   initialScale: PhotoViewComputedScale.contained,
        // ),
        body: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: content['type'] == 'base64'
                  ? MemoryImage(base64Decode(content['images'][index]))
                  : NetworkImage(content['images'][index]) as ImageProvider,
              // initialScale: PhotoViewComputedScale.contained * 0.8,
              minScale: PhotoViewComputedScale.contained * 0.8,
              // maxScale: PhotoViewComputedScale.covered * 1.1,
              // heroAttributes: HeroAttributes(tag: galleryItems[index].id),
            );
          },
          itemCount: content['images'].length,
          // loadingBuilder: (context, progress) => Center(
          //   child: Container(
          //     width: 20.0,
          //     height: 20.0,
          //     child: CircularProgressIndicator(
          //       value: _progress == null
          //           ? null
          //           : _progress.cumulativeBytesLoaded /
          //               _progress.expectedTotalBytes,
          //     ),
          //   ),
          // ),
          // backgroundDecoration: widget.backgroundDecoration,
          // pageController: widget.pageController,
          // onPageChanged: onPageChanged,
        ));
  }
}
