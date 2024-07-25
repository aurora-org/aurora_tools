import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class FavoriteWordManager {
  final int _version = 1;
  final String _databaseName = 'favorite_word.db';

  static const String table = 'main';
  static const String id = 'id';
  static const String _first = 'first';
  static const String _second = 'second';
  static const String uuid = 'uuid';
  static const String _createAt = 'create_at';

  // Search table
  static const String searchTable = 'search_table';
  static const String searchKey = 'search_key';

  static FavoriteWordManager? _instance;
  static FavoriteWordManager get instance => _instance ?? FavoriteWordManager();

  static Database? _database;
  Future<Database> get database async => _database ?? await _initSQL();

  Future<Database> _initSQL() async {
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, _databaseName);

    return await openDatabase(path, version: _version, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    String mainSQL = '''
CREATE TABLE $table (
  $id TEXT PRIMARY KEY,
  $_first TEXT NOT NULL,
  $_second TEXT NOT NULL,
  $uuid TEXT NOT NULL,
  $_createAt DATETIME DEFAULT CURRENT_TIMESTAMP
);
''';

    String searchSQL = '''
CREATE TABLE $searchTable (
  $id TEXT PRIMARY KEY,
  $searchKey TEXT NOT NULL
);
''';

    await db.execute(mainSQL);
    await db.execute(searchSQL);
  }
}
