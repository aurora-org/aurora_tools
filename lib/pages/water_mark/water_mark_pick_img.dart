import 'package:aurora_tools/model/water_marker_model.dart';
import 'package:aurora_tools/util/extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PickImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<WaterMarkerModel>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Center(
          child: Text(
            'Select Image',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          height: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).colorScheme.primary),
          child: ElevatedButton(
            onPressed: () {
              appState.pickImage();
            }.throttle(),
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(Colors.transparent)),
            child: Icon(Icons.add,
                color: Theme.of(context).colorScheme.onPrimary, size: 40),
          ),
        ),
      ],
    );
  }
}
