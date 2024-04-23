import 'package:news_app/model/news_model.dart';
import 'package:news_app/model/user_details_model.dart';
import 'package:news_app/utility/local_database_function.dart';
import 'package:news_app/utility/string.dart';
import 'package:news_app/utility/utilities.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static const int _version = 1;
  static const String _userDetailsTableName = "UserDetails";
  static const String _favouriteNewsDetailsTableName = "Favourite";
  static Database? _database;

  // it for get the database
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  // it initialize Database
  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), AppStrings.dbName),
      onCreate: _onCreate,
      version: _version,
    );
  }

  // create database
  Future<void> _onCreate(Database db, int version) async {
    // create user detail table
    await db.execute('''
    CREATE TABLE $_userDetailsTableName(
      Id INTEGER PRIMARY KEY AUTOINCREMENT,
      UserName TEXT NOT NULL,
      MobileNumber TEXT NOT NULL,
      Email TEXT NOT NULL,
      ProfileImage TEXT
    )
  ''');

    // create a favourite news details table
    await db.execute('''
    CREATE TABLE $_favouriteNewsDetailsTableName(
      Id INTEGER,
      author TEXT NOT NULL,
      title TEXT NOT NULL,
      description TEXT NOT NULL,
      url TEXT,
      urlToImage TEXT,
      publishedAt TEXT,
      content TEXT
    )
  ''');
  }

  // add user details in  local storage
  Future<int> addUserDetails(UserModel userModel) async {
    final db = await database;
    return await db.insert(_userDetailsTableName, userModel.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // get user data to check user is register or not
  Future<bool> getUserDetails(String mobileNumber) async {
    final db = await database;
    var result = await db.query(_userDetailsTableName,
        where: "MobileNumber = ?", whereArgs: [mobileNumber]);
    if (result.isNotEmpty) {
      Utilities.userModel = UserModel.fromJson(result[0]);
      LocalStorage.addUserDetailsFromLocalStorage();
    }
    return result.isNotEmpty;
  }

  // it for update profile image path
  Future<int> updateUserProfileImagePath(String imagePath, int id) async {
    final db = await database;
    return await db.update(
      _userDetailsTableName,
      {'ProfileImage': imagePath},
      where: 'Id = ?',
      whereArgs: [id],
    );
  }

  // add news data in the favourite page
  Future<int> addNewsDetails(NewsModel newsModel, int id) async {
    final db = await database;
    Map<String, dynamic> data = newsModel.toJson();

    // Create a map with the extra field key and value
    Map<String, dynamic> extraFieldMap = {'Id': id};

    // Add the extra field map to the data map using addEntries
    data.addEntries(extraFieldMap.entries);

    return await db.insert(_favouriteNewsDetailsTableName, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // remove from favourite news data
  Future<int> removeFormFavouriteNewsDetails(String publishedAt) async {
    final db = await database;

    return await db.delete(
      _favouriteNewsDetailsTableName,
      where: "publishedAt = ? ",
      whereArgs: [publishedAt],
    );
  }

  // get favourite news data by user id
  Future<List<NewsModel>> getFavouriteNewsDetails(int id) async {
    final db = await database;
    var result = await db.query(_favouriteNewsDetailsTableName,
        where: "Id = ?", whereArgs: [id]);
    List<NewsModel> newsModel = [];
    for (var i in result) {
      newsModel.add(NewsModel.fromJson(i));
    }
    return newsModel;
  }
}
