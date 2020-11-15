import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../model/diary.dart';
import 'dart:async';
import 'dart:io';

class DatabaseHelper{

  static DatabaseHelper _databaseHelper;
  static Database _database;

  String momentsTable = 'moments1';
  String colId = 'id';
  String colTitle = 'title';
  String colNote = 'note';
  String colImage = 'image';
  String colDate = 'date';
  String colTime = 'time';
  String colPlace = 'place';

  DatabaseHelper._createInstance();

  factory DatabaseHelper(){
    if(_databaseHelper == null){
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async{
    if(_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'moments1.db';
    var diaryDatabase = openDatabase(path,version:1,onCreate:_createDb);
    return diaryDatabase;
  }

  void _createDb(Database db,int newVersion) async{
    String sql = "CREATE TABLE $momentsTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colTitle TEXT,$colNote TEXT,$colImage TEXT,$colTime TEXT,$colDate TEXT,$colPlace TEXT)";
    await db.execute(sql);   
  }

  Future<List<Map<String,dynamic>>> getDiaryMapList() async{
    Database db = await this.database;
    var result = await db.query(momentsTable);
    return result;
  }

  Future<int> insertDiary(Diary diary) async{
    Database db = await this.database;
    var result = await db.insert(momentsTable,diary.toMap());
    return result;
  }

  Future<List<Diary>> getPhotos() async {
    var dbClient = await  this.database;
    List<Map> maps = await dbClient.query(momentsTable, columns: [colImage,colDate]);
    List<Diary> imgList = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        imgList.add(Diary.fromMapObject(maps[i]));
      }
    }
    return imgList;
  }

 Future<List<Diary>> getNoteList() async {
		var noteMapList = await getDiaryMapList(); // Get 'Map List' from database
		int count = noteMapList.length;         // Count the number of map entries in db table
		List<Diary> diaryList = List<Diary>();
		// For loop to create a 'Diary List' from a 'Map List'
		for (int i = 0; i < count; i++) {
			diaryList.add(Diary.fromMapObject(noteMapList[i]));
		}
		return diaryList;
	}

Future<int> deleteNote(int id) async {
		var db = await this.database;
		int result = await db.rawDelete('DELETE FROM $momentsTable WHERE $colId = $id');
		return result;
	}


  
}//End of Class