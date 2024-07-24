import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class StartDemoModel extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();

    notifyListeners();
  }

  var favorites = <WordPair>[];

  void addFavorite(WordPair pair) {
    if (favorites.contains(pair)) {
      favorites.remove(pair);
    } else {
      favorites.add(pair);
    }

    notifyListeners();
  }

  void deleteFavorite(WordPair pair) {
    if (favorites.contains(pair)) {
      favorites.remove(pair);
      notifyListeners();
    }
  }
}
