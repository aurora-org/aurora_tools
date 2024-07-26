import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:aurora_tools/instance/image_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as MImage;
import 'package:path/path.dart' as p;

class ImageUtil {
  static Future<ImageItem?> loadImage(String path) async {
    final File imageFile = File(path);

    if (await imageFile.exists()) {
      final Image image = Image.file(imageFile);
      final ImageStream stream = image.image.resolve(ImageConfiguration.empty);
      final Completer<void> completer = Completer<void>();
      var width = 0.0;
      var height = 0.0;

      stream.addListener(ImageStreamListener((ImageInfo info, bool _) {
        width = info.image.width.toDouble();
        height = info.image.height.toDouble();

        completer.complete();
      }));

      await completer.future;

      return ImageItem(path, width, height);
    } else {
      print('File not exists');

      return null;
    }
  }

  static Future<void> addWatermark(
    String imgPath,
    String watermarkText,
  ) async {
    String imgName = p.basenameWithoutExtension(imgPath);
    String imgType = p.extension(imgPath);
    String dirName = p.dirname(imgPath);
    final regex = RegExp(r'\.(jpg|jpeg)$', caseSensitive: false);

    if (regex.hasMatch(imgType)) {}
    String newPath = p.join(dirName, '${imgName}_aurora$imgType');
    final imageBytes = await File(imgPath).readAsBytes();
    final image = MImage.decodeImage(imageBytes)!;

    // TODO: custom font
    MImage.drawString(image, watermarkText, font: MImage.arial24);

    final outputBytes = Uint8List.fromList(regex.hasMatch(imgType)
        ? MImage.encodeJpg(image)
        : MImage.encodePng(image));
    print(newPath);
    final outputFile = File(newPath);

    print(outputBytes.length);
    await outputFile.writeAsBytes(outputBytes);

    print('success');

    // Display a confirmation dialog
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     content: Text('Watermark added and image saved!'),
    //     actions: [
    //       TextButton(
    //         onPressed: () => Navigator.of(context).pop(),
    //         child: Text('OK'),
    //       ),
    //     ],
    //   ),
    // );
  }
}
