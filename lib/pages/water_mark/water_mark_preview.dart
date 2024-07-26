import 'dart:io';

import 'package:aurora_tools/model/water_marker_model.dart';
import 'package:flutter/material.dart';

class WaterMarkPreview extends StatelessWidget {
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
