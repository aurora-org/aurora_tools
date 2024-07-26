import 'package:aurora_tools/model/water_marker_model.dart';
import 'package:aurora_tools/pages/water_mark/water_mark_pick_img.dart';
import 'package:aurora_tools/pages/water_mark/water_mark_space.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WaterMark extends StatefulWidget {
  @override
  State<WaterMark> createState() => _WaterMarkState();
}

class _WaterMarkState extends State<WaterMark> {
  Widget getPage(BuildContext context) {
    Widget page;
    var appState = context.watch<WaterMarkerModel>();

    page = PickImage();

    if (appState.imagePaths.isNotEmpty) {
      page = ImageSpace();
    }

    return page;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WaterMarkerModel(),
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: const FlexibleSpaceBar(
            title: Text('Water Mark'),
            centerTitle: true,
          ),
          centerTitle: true,
        ),
        body: Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Consumer<WaterMarkerModel>(
            builder: (context, value, child) => getPage(context),
          ),
        ),
      ),
    );
  }
}
