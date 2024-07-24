import 'package:aurora_tools/model/start_demo_model.dart';
import 'package:aurora_tools/pages/start_demo/start_demo_home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StartDemoModel(),
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: const FlexibleSpaceBar(
            title: Text('Word Picker'),
            centerTitle: true,
          ),
        ),
        body: StartDemoHome(),
      ),
    );
  }
}
