class Filme {
  int? id;
  String urlImagem;
  String titulo;
  String genero;
  String faixaEtaria;
  String duracao;
  double pontuacao;
  String descricao;
  int anoLancamento;

  Filme({
    this.id,
    required this.urlImagem,
    required this.titulo,
    required this.genero,
    required this.faixaEtaria,
    required this.duracao,
    required this.pontuacao,
    required this.descricao,
    required this.anoLancamento,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'urlImagem': urlImagem,
      'titulo': titulo,
      'genero': genero,
      'faixaEtaria': faixaEtaria,
      'duracao': duracao,
      'pontuacao': pontuacao,
      'descricao': descricao,
      'anoLancamento': anoLancamento,
    };
  }
  factory Filme.fromMap(Map<String, dynamic> map) {
    return Filme(
      id: map['id'],
      urlImagem: map['urlImagem'],
      titulo: map['titulo'],
      genero: map['genero'],
      faixaEtaria: map['faixaEtaria'],
      duracao: map['duracao'],
      pontuacao: map['pontuacao'],
      descricao: map['descricao'],
      anoLancamento: map['anoLancamento'],
    );
  }
}
