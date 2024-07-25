import 'package:aurora_tools/db/favorite_word/dao.dart';
import 'package:aurora_tools/model/start_demo_model.dart';
import 'package:aurora_tools/pages/start_demo/start_demo_my_favorite.dart';
import 'package:aurora_tools/pages/start_demo/start_demo_pick_word.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartDemoHome extends StatefulWidget {
  @override
  State<StartDemoHome> createState() => _StartDemoHomeState();
}

class _StartDemoHomeState extends State<StartDemoHome> {
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    loadingData();
  }

  Future<void> loadingData() async {
    var list = await FavoriteWordDao.instance.queryAll();

    if (!mounted) {
      return;
    }
    var appState = Provider.of<StartDemoModel>(context, listen: false);

    appState.updateFavorite(list);

    print('here');
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (pageIndex) {
      case 0:
        page = PickWord();
        break;
      case 1:
        page = MyFavoriteWord();
        break;
      default:
        throw UnimplementedError('no widget for index $pageIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
                child: NavigationRail(
              extended: constraints.maxWidth > 600,
              destinations: [
                const NavigationRailDestination(
                    icon: Icon(Icons.home), label: Text('Home')),
                const NavigationRailDestination(
                    icon: Icon(Icons.favorite), label: Text('Favorite'))
              ],
              selectedIndex: pageIndex,
              onDestinationSelected: (value) {
                setState(() {
                  pageIndex = value;
                });
              },
            )),
            Expanded(
                child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ))
          ],
        ),
      );
    });
  }
}
