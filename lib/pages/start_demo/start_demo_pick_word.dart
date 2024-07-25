import 'package:aurora_tools/instance/favorite_word.dart';
import 'package:aurora_tools/model/start_demo_model.dart';
import 'package:aurora_tools/util/extension.dart';
import 'package:aurora_tools/util/toast.dart';
import 'package:aurora_tools/widgets/big_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class PickWord extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<StartDemoModel>();
    var pair = appState.current;

    IconData icon;
    if (appState.isExist(pair.first, pair.second)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          const SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // FIXME: throttle not working here. i think the issue is with the context.watch()
              // may be change the state management to provider or bloc
              ElevatedButton.icon(
                  onPressed: () {
                    appState.addFavorite(FavoriteWord(
                        uuid: Uuid().v1(),
                        first: pair.first,
                        second: pair.second));
                    Toast.success(context, 'Success');
                  }.throttle(2000),
                  icon: Icon(icon),
                  label: const Text('Like')),
              const SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  child: const Text('Next'))
            ],
          )
        ],
      ),
    );
  }
}
