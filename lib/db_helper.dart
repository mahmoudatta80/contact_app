import 'package:contact_app/contact_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {

  Database? myDatabase;
  Future<Database?> createDatabase() async{
    if(myDatabase != null) {
      return myDatabase;
    }else {
      String path = join(await getDatabasesPath() , 'roadmap.db');
      myDatabase = await openDatabase(
          path,
          version: 1,
          onCreate: (db,v) {
            db.execute(
              'CREATE TABLE contacts(id INTEGER PRIMARY KEY, contactName TEXT, contactNumber Text, contactImageUrl Text)',
            );
          }
      );
      return myDatabase;
    }
  }

  Future<int> insertToDatabase(ContactModel contactModel) async{
    Database? myDatabase = await createDatabase();
    return myDatabase!.insert('contacts', contactModel.toMap());
  }

  Future<List> readFromDatabase() async{
    Database? myDatabase = await createDatabase();
    return myDatabase!.query('contacts');
  }

  Future<int> updateIntoDatabase(ContactModel contactModel) async{
    Database? myDatabase = await createDatabase();
    return myDatabase!.update('contacts', contactModel.toMap() , where: 'id = ?' , whereArgs: [contactModel.id]);
  }

  Future<int> deleteFromDatabase(int id) async{
    Database? myDatabase = await createDatabase();
    return myDatabase!.delete('contacts' , where: 'id = ?' , whereArgs: [id]);
  }
}
