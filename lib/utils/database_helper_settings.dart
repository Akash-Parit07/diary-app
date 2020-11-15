import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../model/settings.dart';
import 'dart:async';
import 'dart:io';

class DatabaseHelper{

  static DatabaseHelper _databaseHelper;
  static Database _database;

  String settingsTable = 'settings1';
  String colId = 'id';
  String colName = 'name';
  String colDob = 'dob';
  String colImage = 'image';
  String colDarkMode = 'darkmode';
  String colSecurity = 'security';
  String colPin = 'pin';

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
    String path = directory.path + 'settings1.db';
    var settingsDatabase = openDatabase(path,version:1,onCreate:_createDb);
    return settingsDatabase;
  }

  void _createDb(Database db,int newVersion) async{
    String sql = "CREATE TABLE $settingsTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colName TEXT,$colDob TEXT,$colImage TEXT,$colSecurity INTEGER,$colDarkMode INTEGER,$colPin INTEGER)";
    await db.execute(sql);

    sql = "INSERT INTO $settingsTable($colSecurity,$colDarkMode)VALUES(0,0)";
    await db.execute(sql);
  }

  Future<List<Map<String,dynamic>>> getSettingsMapList() async{
    Database db = await this.database;
    var result = await db.query(settingsTable);
    return result;
  }

  Future<int> insertSettings(Settings settings) async{
    Database db = await this.database;
    var result = await db.insert(settingsTable,settings.toMap());
    return result;
  }

 
  Future<int> updateSecurity(Settings settings) async{
    Database db = await this.database;
     Map<String, dynamic> row = {
      colSecurity : settings.security
    };

    // We'll update the first row just as an example
    int id = 1;

    // do the update and get the number of affected rows
    int updateCount = await db.update(
        settingsTable,
        row,
        where: '${colId} = ?',
        whereArgs: [id]);

    return updateCount;
  }

  Future<int> updateDarkMode(Settings settings) async{
    Database db = await this.database;
     Map<String, dynamic> row = {
      colDarkMode : settings.darkMode
    };
    // We'll update the first row just as an example
    int id = 1;

    // do the update and get the number of affected rows
    int updateCount = await db.update(
        settingsTable,
        row,
        where: '${colId} = ?',
        whereArgs: [id]);

    return updateCount;
  }

  Future<int> updateProfile(Settings settings) async{
    Database db = await this.database;
     Map<String, dynamic> row = {
      colName : settings.name,
      colDob : settings.dob
    };
    // We'll update the first row just as an example
    int id = 1;

    // do the update and get the number of affected rows
    int updateCount = await db.update(
        settingsTable,
        row,
        where: '${colId} = ?',
        whereArgs: [id]);

    return updateCount;
  }
 
  Future<int> updatePin(Settings settings) async{
    Database db = await this.database;
     Map<String, dynamic> row = {
      colPin : settings.pin,
    };
    // We'll update the first row just as an example
    int id = 1;

    // do the update and get the number of affected rows
    int updateCount = await db.update(
        settingsTable,
        row,
        where: '${colId} = ?',
        whereArgs: [id]);

    return updateCount;
  }
 
 Future<List<Settings>> getNoteList() async {
		var noteMapList = await getSettingsMapList(); // Get 'Map List' from database
		int count = noteMapList.length;         // Count the number of map entries in db table
		List<Settings> settingsList = List<Settings>();
		// For loop to create a 'Settings List' from a 'Map List'
		for (int i = 0; i < count; i++) {
			settingsList.add(Settings.fromMapObject(noteMapList[i]));
      //print(noteMapList[i]);
		}
   // print(settingsList[0].security);
   // print(settingsList[0].darkMode);
		return settingsList;
	}


  
}//End of Class