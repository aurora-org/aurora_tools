import 'dart:io';

import 'package:aurora_tools/model/water_marker_model.dart';
import 'package:aurora_tools/util/image.dart';
import 'package:aurora_tools/util/toast.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class WaterMarkPreview extends StatefulWidget {
  @override
  State<WaterMarkPreview> createState() => _WaterMarkPreviewState();
}

class _WaterMarkPreviewState extends State<WaterMarkPreview> {
  final TextEditingController _textController = TextEditingController();
  String _waterMarkText = 'Aurora Water Mark';
  double _fontSize = 0.02;
  double _x = 0;
  double _y = 0;
  double _xPosition = 0.02;
  double _yPosition = 0.02;
  // TODO: opacity
  double _opacity = 0.5;
  bool _loading = false;

  Future<void> _requestPermission() async {
    // TODO: use "photos" belowd android 13
    await Permission.notification.request();
    PermissionStatus result = await Permission.photos.request();

    if (result.isDenied) {
      result = Platform.isIOS
          ? await Permission.photos.request()
          : await Permission.storage.request();
    }

    if (!result.isGranted && !result.isLimited) {
      // TODO: open setting here
    }
  }

  Future<void> _initWaterMark(BuildContext context) async {
    final WaterMarkerModel appState =
        ModalRoute.of(context)!.settings.arguments as WaterMarkerModel;
    final imageItem = await ImageUtil.loadImage(appState.imagePaths[0]);

    if (imageItem?.height == 0 || imageItem?.width == 0) {
      return;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenContainer = screenWidth - 32;
    final currentWidth = 500 * imageItem!.width / imageItem.height;
    final imgWidth =
        currentWidth > screenContainer ? screenContainer : currentWidth;

    setState(() {
      _fontSize = imgWidth * 0.02;
      _x = imgWidth * _xPosition;
      _y = 500 * _yPosition;
    });
  }

  @override
  void initState() {
    super.initState();

    _textController.addListener(() async {
      setState(() {
        _waterMarkText = _textController.text;
      });
    });

    _requestPermission();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      _initWaterMark(context);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WaterMarkerModel appState =
        ModalRoute.of(context)!.settings.arguments as WaterMarkerModel;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const FlexibleSpaceBar(
          title: Text('Water Mark Preview'),
          centerTitle: true,
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        color: Theme.of(context).colorScheme.primaryContainer,
        child: ListView(
          children: [
            Container(
              height: 500,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Image.file(
                      File(appState.imagePaths[0]),
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    left: _x,
                    top: _y,
                    child: Opacity(
                        opacity: _opacity,
                        child: Text(
                          _waterMarkText,
                          style: TextStyle(
                            fontFamily: 'FiraCode',
                            fontSize: _fontSize,
                            color: Colors.red,
                          ),
                        )),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 44,
              child: TextField(
                controller: _textController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Aurora Water Mark')),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 44,
              child: FloatingActionButton(
                onPressed: () async {
                  if (_loading) {
                    return;
                  }

                  setState(() {
                    _loading = true;
                  });
                  final result = await appState.waterMarkAll(
                      text: _waterMarkText,
                      x: _xPosition,
                      y: _yPosition,
                      bold: true);

                  if (result) {
                    Toast.success(context, 'Finished');
                  }

                  setState(() {
                    _loading = false;
                  });
                },
                backgroundColor: Theme.of(context).colorScheme.error,
                // FIXME: io will block the UI thread
                child: _loading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text(
                        'Finish',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onError),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
