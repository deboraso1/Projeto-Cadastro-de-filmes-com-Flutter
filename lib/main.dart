import 'package:flutter/material.dart';
import 'package:projeto_cadastro_filmes/views/lista_filmes.dart';


void main() {
  runApp(FilmeApp());
}

class FilmeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de filmes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListaFilmesScreen(),
    );
  }
}
