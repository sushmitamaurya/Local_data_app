import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/contact.dart';

class DatabaseForm {
  static const _databaseName = 'ContactData.db';
  static const _databaseVersion = 1;
  DatabaseForm._();
  static final DatabaseForm instace = DatabaseForm._();

  late Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDatabase();
    return database;
  }

  initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDirectory.path, _databaseName);
    return await openDatabase(dbPath,
        version: _databaseVersion, onCreate: _onCreateDB);
  }

  _onCreateDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE ${Contact.tblContact}(
  ${Contact.colID} INTEGER PRIMARY KEY AUTOINCREMENT,
  ${Contact.colName} TEXT NOT NULL,
  ${Contact.colMobile} TEXT NOT NULL
)
''');
  }

  Future<int> insertContact(Contact contact) async {
    Database db = await database;
    return await db.insert(
      Contact.tblContact,
      contact.toMap(),
    );
  }

  Future<int> updateContact(Contact contact) async {
    Database db = await database;
    return await db.update(Contact.tblContact, contact.toMap(),
        where: '${Contact.colID}=?', whereArgs: [contact.id]);
  }

  Future<int> deleteContact(int id) async {
    Database db = await database;
    return await db.delete(Contact.tblContact,
        where: '${Contact.colID}=?', whereArgs: [id]);
  }

  Future<List<Contact>> fetchContacts() async {
    Database db = await database;
    List contacts = await db.query(Contact.tblContact);
    return contacts.length == 0
        ? []
        : contacts.map((e) => Contact.fromMap(e)).toList();
  }
}
