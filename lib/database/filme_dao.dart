import 'package:sqflite/sqflite.dart';
import 'filme_connection.dart';
import '../model/filme.dart';

class FilmeDao {
  static Future<int> inserir(Filme filme) async {
    Database db = await FilmeConnection.getConnection();
    return await db.insert('filmes', filme.toMap());
  }

  static Future<List<Filme>> buscarTodos() async {
    Database db = await FilmeConnection.getConnection();
    List<Map<String, dynamic>> maps = await db.query('filmes');
    return maps.map((map) => Filme.fromMap(map)).toList();
  }

  static Future<int> atualizar(Filme filme) async {
    Database db = await FilmeConnection.getConnection();
    return await db.update('filmes', filme.toMap(),
        where: 'id = ?', whereArgs: [filme.id]);
  }

  static Future<int> deletar(int id) async {
    Database db = await FilmeConnection.getConnection();
    return await db.delete('filmes', where: 'id = ?', whereArgs: [id]);
  }
}
