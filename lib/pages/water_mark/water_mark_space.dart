import 'dart:io';

import 'package:aurora_tools/model/water_marker_model.dart';
import 'package:aurora_tools/util/extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageSpace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<WaterMarkerModel>();
    // TODO: read from local storage
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = (screenWidth - 16 * 4) / 3;
    int row = (appState.imagePaths.length / 3).ceil();
    double height = row * (itemWidth + 16);

    return Scaffold(
        floatingActionButton: SizedBox(
          width: screenWidth - 16 * 2,
          height: 44,
          child: FloatingActionButton(
            onPressed: () {
              // FIXME: why i get a new context here?
              Navigator.pushNamed(context, '/water_mark/preview',
                  arguments: context.read<WaterMarkerModel>());
            },
            backgroundColor: Theme.of(context).colorScheme.error,
            child: Text(
              'Next',
              style: TextStyle(color: Theme.of(context).colorScheme.onError),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SizedBox(
                height: height,
                child: GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 1),
                    children: appState.imagePaths
                        .map((i) => Image.file(File(i), fit: BoxFit.cover))
                        .toList()),
              ),
              const SizedBox(height: 16),
              Container(
                height: 44,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Theme.of(context).colorScheme.primary),
                child: ElevatedButton.icon(
                  onPressed: () {
                    appState.pickImage();
                  }.throttle(),
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent)),
                  icon: Icon(Icons.edit,
                      color: Theme.of(context).colorScheme.onPrimary, size: 40),
                  label: Text('Edit',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary)),
                ),
              ),
              const SizedBox(height: 60)
            ],
          ),
        ));
  }
}
