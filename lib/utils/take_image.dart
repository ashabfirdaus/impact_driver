import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_picker/image_picker.dart';

import 'notification_bar.dart';

class TakeImage {
  static Future imageSelector(BuildContext context, String pickerType) async {
    final picker = ImagePicker();
    XFile? pickedFile;
    switch (pickerType) {
      case "gallery":
        pickedFile = await picker.pickImage(
            source: ImageSource.gallery, maxHeight: 720.0, imageQuality: 65);
        break;
      case "camera":
        pickedFile = await picker.pickImage(
            source: ImageSource.camera, maxHeight: 720.0, imageQuality: 65);
        break;
    }

    if (pickedFile != null) {
      File rotatedImage =
          await FlutterExifRotation.rotateImage(path: pickedFile.path);
      final bytes = await rotatedImage.readAsBytes();
      return 'data:image/jpeg;base64,${base64Encode(bytes)}';
    } else {
      NotificationBar.toastr('Batal mengambil gambar', 'error');
      return null;
    }
  }
}
