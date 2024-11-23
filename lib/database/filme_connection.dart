import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// CRIANDO BANCO DE DADOS
class FilmeConnection {
  //CRIAR INSTANCIA DO DB
  static Future<Database> getConnection() async {
    // RETORNA CAMINHO DB
    String path = await getDatabasesPath();
    // CONCATENA STRING DO CAMINHO DO DB
    String dbPath = join(path, "filmes.db");
    // ACESSA DB
    // onCreate cria se o banco não existir e se existir, retorna um objeto database
    return openDatabase(
      dbPath,
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE filmes ("
              "id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "urlImagem TEXT, "
              "titulo TEXT, "
              "genero TEXT, "
              "faixaEtaria TEXT, "
              "duracao TEXT, "
              "pontuacao REAL, "
              "descricao TEXT, "
              "anoLancamento INTEGER"
              ")",
        );
      },
      version: 1,
    );
  }
}
