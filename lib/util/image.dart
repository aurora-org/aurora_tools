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

  static Future<void> addWatermark({
    required String imgPath,
    required String watermarkText,
    double percentage = 0.02,
    // FIXME: use Font class to extend the constant name
    // const String fontFamily = 'FiraCode', // TODO: enum
    String position = 'top-center', // TODO: enum
  }) async {
    // TODO: loading here
    ImageItem? imageItem = await loadImage(imgPath);

    if (imageItem == null) {
      return;
    }

    String imgName = p.basenameWithoutExtension(imgPath);
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
            color: Colors.red,
            fontFamily: 'FiraCode',
            fontWeight: FontWeight.bold));
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

    print(imageItem.width / 2 - textWidth / 2);
    print(imageItem.height * 0.02);

    MImage.Image newImage = MImage.compositeImage(image, textImage,
        dstX: (imageItem.width / 2 - textWidth / 2).toInt(),
        dstY: (imageItem.height * 0.02).toInt());

    // MImage.Image newImage =
    //     MImage.compositeImage(image, textImage, dstX: 0, dstY: 0);

    final outputBytes = Uint8List.fromList(
        isJpg ? MImage.encodeJpg(newImage) : MImage.encodePng(newImage));

    if (await Permission.photos.request().isGranted) {
      final result = await ImageGallerySaver.saveImage(outputBytes,
          name: '${imgName}_aurora$imgType');

      print('success');
      print(result);

      // TODO: end loading & back here.
    } else {
      print('Permission not granted');
    }

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
