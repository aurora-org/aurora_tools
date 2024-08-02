import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:aurora_tools/instance/image_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as MImage;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

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

  static Future<Uint8List?> getWatermarkedImageBytes({
    required String imgPath,
    required String watermarkText,
    double percentage = 0.02,
    double x = 0.0,
    double y = 0.0,
    bool bold = false,
    // TODO: use Font class to extend the constant name
    // const String fontFamily = 'FiraCode', // TODO: enum
  }) async {
    ImageItem? imageItem = await loadImage(imgPath);

    if (imageItem == null) {
      return null;
    }

    String imgType = p.extension(imgPath);
    final regex = RegExp(r'\.(jpg|jpeg)$', caseSensitive: false);
    final isJpg = regex.hasMatch(imgType);
    final isHorizontal = imageItem.width >= imageItem.height;

    // load original image
    final imageBytes = await File(imgPath).readAsBytes();
    final image = MImage.decodeImage(imageBytes)!;

    // generator text image
    double fontSize = (isHorizontal
        ? imageItem.height * percentage
        : imageItem.width * percentage);

    TextSpan textSpan = TextSpan(
        text: watermarkText,
        style: TextStyle(
            fontSize: fontSize,
            color: const Color.fromRGBO(255, 255, 255, 0.61),
            fontFamily: 'FiraCode',
            fontWeight: bold ? FontWeight.bold : FontWeight.normal));
    TextPainter textPainter =
        TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout();
    PictureRecorder recorder = PictureRecorder();
    Canvas canvas = Canvas(recorder);
    textPainter.paint(canvas, Offset(0, 0)); // (x, offset)
    final textWidth = textPainter.width;
    final textHeight = textPainter.height;

    Picture picture = recorder.endRecording();
    final textImageTemp =
        await picture.toImage(textWidth.toInt(), textHeight.toInt());
    ByteData? textImageData =
        await textImageTemp.toByteData(format: ImageByteFormat.png);
    Uint8List textImageBytes = textImageData!.buffer.asUint8List();
    final textImage = MImage.decodeImage(textImageBytes)!;

    MImage.Image newImage = MImage.compositeImage(image, textImage,
        dstX: (x == 0
                ? (imageItem.width / 2 - textWidth / 2)
                : x * imageItem.width)
            .toInt(),
        dstY: (y * imageItem.height).toInt());

    return Uint8List.fromList(
        isJpg ? MImage.encodeJpg(newImage) : MImage.encodePng(newImage));
  }

  static Future<void> saveImage(Uint8List imageBytes, String fileName) async {
    if (await Permission.photos.request().isGranted) {
      final result =
          await ImageGallerySaver.saveImage(imageBytes, name: fileName);

      // TODO: end loading & back here.
    } else {
      print('Permission not granted');
    }
  }

  static Future<void> addWatermark({
    required String imgPath,
    required String watermarkText,
    double percentage = 0.02,
    double x = 0.0,
    double y = 0.0,
    bool bold = false,
    // TODO: use Font class to extend the constant name
    // const String fontFamily = 'FiraCode', // TODO: enum
  }) async {
    String imgName = p.basenameWithoutExtension(imgPath);
    String imgType = p.extension(imgPath);

    final outputBytes = await getWatermarkedImageBytes(
        imgPath: imgPath, watermarkText: watermarkText, x: x, y: y, bold: bold);

    await saveImage(outputBytes!, '${imgName}_aurora$imgType');
  }
}
