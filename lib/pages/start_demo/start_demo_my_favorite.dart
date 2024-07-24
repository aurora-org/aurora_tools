import 'package:aurora_tools/model/start_demo_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyFavoriteWord extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<StartDemoModel>();
    var list = appState.favorites;

    // TODO: store in local storage

    if (appState.favorites.isEmpty) {
      return const Center(
        child: Text('Empty'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have ${list.length} words now!'),
        ),
        for (var pair in list)
          ListTile(
            leading: const Icon(Icons.favorite),
            title: Text('${pair.first} ${pair.second}'),
            trailing: IconButton(
              onPressed: () {
                appState.deleteFavorite(pair);
              },
              icon: const Icon(Icons.delete),
            ),
          )
      ],
    );
  }
}
