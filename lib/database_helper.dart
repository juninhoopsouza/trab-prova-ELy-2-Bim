import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:preferencias/pessoa.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database _db;
  DatabaseHelper.internal();
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'notes.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE pessoa(id INTEGER PRIMARY KEY,nome TEXT, telefone TEXT, cidade TEXT, email TEXT)');
  }

  Future<int> inserirPessoa(Pessoa pessoa) async {
    var dbClient = await db;
    var result = await dbClient.insert("pessoa", pessoa.toMap());
//é possivel executar comandos SQL
//var result = await dbClient.rawInsert(
//'INSERT INTO pessoa (nome, telefone)
// VALUES (\'${pessoa.nome}\', \'${pessoa.telefone}\')');
    return result;
  }

  Future<List> getPessoas() async {
    var dbClient = await db;
    var result = await dbClient.query("pessoa",
        columns: ["id", "nome", "telefone", "cidade", "email"]);
//var result = await dbClient.rawQuery('SELECT * FROM pessoa');
    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery('SELECT COUNT(*) FROM pessoa'));
  }

  Future<Pessoa> getPessoa(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query("pessoa",
        columns: ["id", "nome", "telefone", "cidade", "email"],
        where: 'ide = ?',
        whereArgs: [id]);
//var result = await dbClient.rawQuery('SELECT * FROM $"pessoa"
//WHERE $columnId = $id');
    if (result.length > 0) {
      return new Pessoa.fromMap(result.first);
    }
    return null;
  }

  Future<int> deletePessoa(int id) async {
    var dbClient = await db;
    return await dbClient.delete("pessoa", where: 'id = ?', whereArgs: [id]);
//return await dbClient.rawDelete('DELETE FROM $"pessoa" WHERE
//$columnId = $id');
  }

  Future<int> updatePessoa(Pessoa pessoa) async {
    var dbClient = await db;
    return await dbClient.update("pessoa", pessoa.toMap(),
        where: "id = ?", whereArgs: [pessoa.id]);
//return await dbClient.rawUpdate(
//'UPDATE $"pessoa" SET $columnTitle = \'${note.title}\',
// $columnDescription = \'${note.description}\' WHERE $columnId =
// ${note.id}');
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
