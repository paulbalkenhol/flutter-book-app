import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'book.dart';
import 'package:path/path.dart';

class DBHelper {
  DBHelper._();

  static final DBHelper db = DBHelper._();

  static Database _database;
  static const String ID = "id";
  static const String AUTHOR = "author";
  static const String TITLE = "title";
  static const String READINGTIME = "readingtime";
  static const String DESCRIPTION = "despription";
  static const String PAGES = "pages";
  static const String DB_NAME = "books_database2.db";
  static const String TABLE = "books";

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await initDB();
      return _database;
    }
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    return await openDatabase(path,
        version: 1, onOpen: (db) {}, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE($ID INTEGER PRIMARY KEY, $DESCRIPTION Text, $AUTHOR TEXT, $TITLE TEXT, $READINGTIME INTEGER, $PAGES INTEGER)");
  }

  Future<void> insertBook(Book book) async {
    Database db = await database;
    await db.insert(TABLE, book.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Book>> getBooks() async {
    Database db = await database;
    List<Map> maps =
        await db.query(TABLE, columns: [TITLE, AUTHOR, READINGTIME, PAGES, DESCRIPTION]);
    List<Book> books = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        books.add(Book.fromMap(maps[i]));
      }
    }
    return books;
  }

  Future<void> delete(int id) async {
    Database db = await database;
    db.delete(TABLE, where: "$ID = ?", whereArgs: [id]);
  }

  Future<void> update(Book book) async {
    Database db = await database;
    db.update(TABLE, book.toMap(), where: "$ID = ?", whereArgs: [book.id]);
  }

  Future<void> close() async {
    Database db = await database;
    db.close();
  }

  Future<int> entriesCount() async {
    Database db = await database;
    int number =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $TABLE'));
    return number;
  }
}
