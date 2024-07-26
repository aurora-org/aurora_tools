import 'package:aurora_tools/model/start_demo_model.dart';
import 'package:aurora_tools/model/water_marker_model.dart';
import 'package:aurora_tools/pages/home/home.dart';
import 'package:aurora_tools/pages/start_demo/start_demo_home.dart';
import 'package:aurora_tools/pages/water_mark/water_mark.dart';
import 'package:aurora_tools/pages/water_mark/water_mark_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => StartDemoModel()),
      ChangeNotifierProvider(create: (_) => WaterMarkerModel())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (_) => HomePage(),
        '/start_demo': (_) => StartDemoHome(),
        '/water_mark': (_) => WaterMark(),
        '/water_mark/preview': (_) => WaterMarkPreview()
      },
      initialRoute: '/home',
      title: 'Aurora Tools',
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
    );
  }
}
