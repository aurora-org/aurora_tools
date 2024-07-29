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

  Future<void> waterMarkImage() async {
    if (imagePaths.isNotEmpty) {
      String imgPath = imagePaths[0];
      // TODO: multi image watermark
      ImageUtil.addWatermark(
          imgPath: imgPath, watermarkText: "==== Watermarked ==== ==>>");
    }
  }
}
