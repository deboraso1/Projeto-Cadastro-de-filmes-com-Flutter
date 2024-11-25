import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../database/filme_dao.dart';
import '../model/filme.dart';
import 'cadastro_filme.dart';
import 'detalhe_filmes.dart';

class ListaFilmesScreen extends StatefulWidget {
  @override
  _ListaFilmesScreenState createState() => _ListaFilmesScreenState();
}

class _ListaFilmesScreenState extends State<ListaFilmesScreen> {
  late Future<List<Filme>> filmesFuture;
// Inicializa a lista de filmes ao carregar a tela
  @override
  void initState() {
    super.initState();
    _atualizarFilmes();
  }
  // Atualiza a lista de filmes buscando todos os registros no banco de dados
  void _atualizarFilmes() {
    setState(() {
      filmesFuture = FilmeDao.buscarTodos();
    });
  }
// Navega para a tela de cadastro/edição de filmes
  void _navegarParaCadastro({Filme? filme}) async {
    final resultado = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CadastroFilmeScreen(filme: filme), // Passa o filme se for edição
      ),
    );
// Passa o filme se for edição
    if (resultado == true) {
      _atualizarFilmes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Filmes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundColor: Colors.blue,
              child: const Icon(
                Icons.info,
                color: Colors.white,
              ),
            ),
            // Exibe um diálogo com informações sobre a equipe
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Equipe:'),
                    content: const Text(
                        'Débora Silva Oliveira\nThamires Gabriela Rosa da Silveira'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    backgroundColor: Colors.white,
                    actions: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue,
                        ),
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Filme>>(
        future: filmesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum filme cadastrado.'));
          }
          final filmes = snapshot.data!;
          return ListView.builder(
            itemCount: filmes.length,
            itemBuilder: (context, index) {
              final filme = filmes[index];
              return Dismissible(
                key: ValueKey(filme.id),
                direction: DismissDirection.endToStart,
                // Deslize para a esquerda
                onDismissed: (direction) async {
                  await FilmeDao.deletar(filme.id!);  // Deleta o filme do banco de dados
                  _atualizarFilmes(); //atualiza lista após deletar
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius
                        .zero,
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        // Quando o card for tocado, exibe o menu na parte inferior
                        _showPopupMenu(context, filme);
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          filme.urlImagem.isNotEmpty
                              ? Image.network(
                            filme.urlImagem,
                            width: 80,
                            height: 120,
                            fit: BoxFit.cover,
                          )
                              : const Icon(Icons.movie, size: 80),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  filme.titulo,
                                  style: const TextStyle(fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  filme.genero,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  filme.duracao,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                                const SizedBox(height: 24),
                                RatingBarIndicator(
                                  rating: filme.pontuacao.toDouble(),
                                  itemBuilder: (context, _) =>
                                  const Icon(Icons.star, color: Colors.yellow),
                                  itemCount: 5,
                                  itemSize: 20.0,
                                  direction: Axis.horizontal,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navegarParaCadastro(), //navegar para cadastro
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
        elevation: 6.0,
      ),
    );
  }

  //  exibir o menu no fundo da tela
  void _showPopupMenu(BuildContext context, Filme filme) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 120,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                title: const Center(child: Text('Exibir Detalhes')),
                onTap: () {
                  Navigator.of(context).pop(); // Fecha o menu
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DetalhesFilmeScreen(filme: filme),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Center(child: Text('Alterar')),
                onTap: () {
                  Navigator.of(context).pop(); // Fecha o menu
                  _navegarParaCadastro(
                      filme: filme); // Navega para a tela de cadastro
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
