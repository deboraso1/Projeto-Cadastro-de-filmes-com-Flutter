import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../database/filme_dao.dart';
import '../model/filme.dart';

class CadastroFilmeScreen extends StatefulWidget {
  final Filme? filme;
  CadastroFilmeScreen({Key? key, this.filme}) : super(key: key);
  @override
  _CadastroFilmeScreenState createState() => _CadastroFilmeScreenState();
}
class _CadastroFilmeScreenState extends State<CadastroFilmeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _urlImagemController = TextEditingController();
  final _tituloController = TextEditingController();
  final _generoController = TextEditingController();
  final _duracaoController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _anoLancamentoController = TextEditingController();

  String _faixaEtaria = 'Livre';
  double _pontuacao = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.filme != null) {
      _urlImagemController.text = widget.filme!.urlImagem;
      _tituloController.text = widget.filme!.titulo;
      _generoController.text = widget.filme!.genero;
      _faixaEtaria = widget.filme!.faixaEtaria;
      _duracaoController.text = widget.filme!.duracao;
      _pontuacao = widget.filme!.pontuacao;
      _descricaoController.text = widget.filme!.descricao;
      _anoLancamentoController.text = widget.filme!.anoLancamento.toString();
    }
  }

  void _salvarFilme() async {
    if (_formKey.currentState!.validate()) {
      final filme = Filme(
        id: widget.filme?.id,
        urlImagem: _urlImagemController.text,
        titulo: _tituloController.text,
        genero: _generoController.text,
        faixaEtaria: _faixaEtaria,
        duracao: _duracaoController.text,
        pontuacao: _pontuacao,
        descricao: _descricaoController.text,
        anoLancamento: int.tryParse(_anoLancamentoController.text) ?? 0,
      );

      if (widget.filme == null) {
        await FilmeDao.inserir(filme);
      } else {
        await FilmeDao.atualizar(filme);
      }

      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.filme == null ? 'Cadastrar Filme' : 'Editar Filme',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                    'URL da Imagem', _urlImagemController, TextInputType.url),
                const SizedBox(height: 16),
                _buildTextField(
                    'Título', _tituloController, TextInputType.text),
                const SizedBox(height: 16),
                _buildTextField(
                    'Gênero', _generoController, TextInputType.text),
                const SizedBox(height: 16),
                _buildDropDown(),
                const SizedBox(height: 16),
                _buildTextField(
                    'Duração', _duracaoController, TextInputType.text),
                const SizedBox(height: 16),
                _buildSmoothStarRating(),
                const SizedBox(height: 16),
                _buildTextField(
                    'Ano', _anoLancamentoController, TextInputType.number),
                const SizedBox(height: 16),
                _buildTextField(
                    'Descrição', _descricaoController, TextInputType.multiline,
                    maxLines: 3),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _salvarFilme,
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: const Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      TextInputType keyboardType, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 8, vertical: 4),
          border: UnderlineInputBorder(),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'O campo $label é obrigatório!';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropDown() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Faixa Etária:',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(width: 18),
        SizedBox(
          width: 100,
          child: DropdownButton<String>(
            value: _faixaEtaria,
            dropdownColor: Colors.white,
            items: ['Livre', '10', '12', '14', '16', '18']
                .map((value) =>
                DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                ))
                .toList(),
            onChanged: (newValue) {
              setState(() {
                _faixaEtaria = newValue!;
              });
            },
            underline: SizedBox.shrink(),
            icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmoothStarRating() {
    return Row(
      children: [
        Text(
          'Nota: ',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(width: 8),
        RatingBar.builder(
          initialRating: _pontuacao,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 40,
          itemPadding: EdgeInsets.symmetric(horizontal: 4),
          itemBuilder: (context, index) {
            return Icon(
              Icons.star,
              color: _pontuacao > index ? Colors.blue : Colors.blue.withOpacity(
                  0.2),
              size: 40,
              semanticLabel: 'Rating Star',
            );
          },
          onRatingUpdate: (rating) {
            setState(() {
              _pontuacao = rating;
            });
          },
        ),
      ],
    );
  }
}