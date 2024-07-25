import 'package:aurora_tools/db/favorite_word/manager.dart';
import 'package:aurora_tools/instance/favorite_word.dart';
import 'package:sqflite/sqflite.dart';

class FavoriteWordDao {
  static FavoriteWordDao? _instance;
  static FavoriteWordDao get instance => _instance ?? FavoriteWordDao();

  Future<int> insert(FavoriteWord word) async {
    Database db = await FavoriteWordManager.instance.database;

    return await db.insert(FavoriteWordManager.table, word.toJson());
  }

  Future<int> delete(String id) async {
    Database db = await FavoriteWordManager.instance.database;

    return await db.delete(FavoriteWordManager.table,
        where: '${FavoriteWordManager.uuid} = ?', whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    Database db = await FavoriteWordManager.instance.database;

    return await db.delete(FavoriteWordManager.table);
  }

  Future<List<FavoriteWord>> queryAll() async {
    Database db = await FavoriteWordManager.instance.database;

    var result = await db.query(FavoriteWordManager.table);

    if (result.isNotEmpty) {
      return result.map((e) => FavoriteWord.fromJson(e)).toList();
    } else {
      return [];
    }
  }
}
