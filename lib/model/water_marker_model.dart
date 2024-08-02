import 'dart:async';

import 'package:aurora_tools/util/image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class WaterMarkerModel extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  var imagePaths = <String>[];

  Future<void> pickImage() async {
    var list = await _picker.pickMultiImage();
    if (list.isNotEmpty) {
      print(list[0].path);
    }

    imagePaths = list.reversed.map((i) => i.path).toList();

    notifyListeners();
  }

  Future<bool> waterMarkAll(
      {required String text,
      double x = 0,
      double y = 0,
      bool bold = false}) async {
    if (imagePaths.isNotEmpty) {
      bool success = true;
      for (var imgPath in imagePaths) {
        bool result = await waterMarkImage(
            path: imgPath, text: text, x: x, y: y, bold: bold);

        if (!result) {
          success = false;
        }
      }

      return success;
    }

    return false;
  }

  Future<bool> waterMarkImage(
      {required String path,
      required String text,
      double x = 0,
      double y = 0,
      bool bold = false}) async {
    await ImageUtil.addWatermark(
        imgPath: path, watermarkText: text, x: x, y: y, bold: bold);

    return true;
  }
}
