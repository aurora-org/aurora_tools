import 'package:aurora_tools/db/favorite_word/dao.dart';
import 'package:aurora_tools/instance/favorite_word.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class StartDemoModel extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();

    notifyListeners();
  }

  var favorites = <FavoriteWord>[];

  void updateFavorite(list) {
    favorites = list;

    notifyListeners();
  }

  bool isExist(String first, String second) {
    for (var b in favorites) {
      if (first == b.first && second == b.second) {
        return true;
      }
    }

    return false;
  }

  Future<void> addFavorite(FavoriteWord word) async {
    if (isExist(word.first, word.second)) {
      var exists = favorites
          .firstWhere((e) => e.first == word.first && e.second == word.second);
      await FavoriteWordDao.instance.delete(exists.uuid);
      favorites.remove(exists);
    } else {
      await FavoriteWordDao.instance.insert(word);
      favorites.add(word);
    }

    notifyListeners();
  }

  Future<void> deleteFavorite(FavoriteWord word) async {
    if (favorites.contains(word)) {
      favorites.remove(word);
      await FavoriteWordDao.instance.delete(word.uuid);
      notifyListeners();
    }
  }
}
