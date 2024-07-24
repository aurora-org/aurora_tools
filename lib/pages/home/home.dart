import 'package:aurora_tools/pages/start_demo/start_demo.dart';
import 'package:aurora_tools/util/extension.dart';
import 'package:aurora_tools/util/toast.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: const FlexibleSpaceBar(
          title: Text('Aurora Tools'),
          centerTitle: true,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 4),
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => StartDemo()));
              },
              icon: const Icon(Icons.book),
              label: const Text('Word Picker'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Toast.info(context, 'Coming Soon...');
              }.throttle(2000),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Water Mark'),
            ),
          ],
        ),
      ),
      // body:
    );
  }
}
