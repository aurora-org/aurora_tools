import 'dart:io';

import 'package:aurora_tools/model/water_marker_model.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class WaterMarkPreview extends StatefulWidget {
  @override
  State<WaterMarkPreview> createState() => _WaterMarkPreviewState();
}

class _WaterMarkPreviewState extends State<WaterMarkPreview> {
  Future<void> requestPermission() async {
    // TODO: use "photos" belowd android 13
    await Permission.notification.request();
    PermissionStatus result = await Permission.photos.request();

    if (result.isDenied) {
      print('request again');
      result = Platform.isIOS
          ? await Permission.photos.request()
          : await Permission.storage.request();
    }

    if (!result.isGranted && !result.isLimited) {
      // TODO: open setting here
    }
  }

  @override
  void initState() {
    super.initState();

    requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    final WaterMarkerModel appState =
        ModalRoute.of(context)!.settings.arguments as WaterMarkerModel;

    print('here');
    print('${appState.imagePaths.length} hi there');
    print('end');

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const FlexibleSpaceBar(
          title: Text('Water Mark Preview'),
          centerTitle: true,
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        color: Theme.of(context).colorScheme.primaryContainer,
        child: ListView(
          children: [
            Image.file(
              height: 500,
              File(appState.imagePaths[0]),
              fit: BoxFit.contain,
            ),
            SizedBox(
              height: 44,
              child: FloatingActionButton(
                onPressed: () {
                  appState.waterMarkImage();
                },
                backgroundColor: Theme.of(context).colorScheme.error,
                child: Text(
                  'Finish',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onError),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
