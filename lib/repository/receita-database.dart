import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/receita.dart';

class ReceitaDatabase {
  static final ReceitaDatabase instance = ReceitaDatabase._init();
  static Database? _database;

  ReceitaDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('receitas.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE receitas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        imagem TEXT,
        passos TEXT NOT NULL,
        ingredientes TEXT NOT NULL,
        categoria TEXT NOT NULL
      )
    ''');
  }

  Future<Receita> create(Receita receita) async {
    final db = await instance.database;
    final id = await db.insert('receitas', receita.toMap());
    return receita..copyWith(id: id);
  }

  Future<List<Receita>> readAllReceitas() async {
    final db = await instance.database;
    final result = await db.query('receitas');
    return result.map((json) => Receita.fromMap(json)).toList();
  }

  Future<int> update(Receita receita) async {
    final db = await instance.database;
    return db.update(
      'receitas',
      receita.toMap(),
      where: 'id = ?',
      whereArgs: [receita.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'receitas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
