import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../model/filme.dart';

class DetalhesFilmeScreen extends StatelessWidget {
  final Filme filme;

  const DetalhesFilmeScreen({Key? key, required this.filme}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Detalhes',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: filme.urlImagem.isNotEmpty
                  ? Image.network(
                filme.urlImagem,
                height: 250,
                fit: BoxFit.cover,
              )
                  : const Icon(Icons.movie, size: 80),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    filme.titulo,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  filme.anoLancamento.toString(),
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  filme.genero,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  _formatarFaixaEtaria(filme.faixaEtaria),
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  filme.duracao,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                RatingBarIndicator(
                  rating: filme.pontuacao,
                  itemBuilder: (context, _) =>
                  const Icon(Icons.star, color: Colors.amber),
                  itemCount: 5,
                  itemSize: 20.0,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Descrição
            Text(
              'Descrição',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              filme.descricao,
              style: const TextStyle(fontSize: 14, height: 1.5),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
  String _formatarFaixaEtaria(String faixaEtaria) {
    if (faixaEtaria.toLowerCase() == 'livre') {
      return 'Livre';
    }
    return '$faixaEtaria anos';
  }
}
