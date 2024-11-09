import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:easy_cook/model/receita.dart';
import 'package:easy_cook/repository/receita-database.dart';
import '../model/categoria-receita.dart';

class CadastroReceita extends StatefulWidget {
  final Receita? receita;

  CadastroReceita({this.receita});

  @override
  _CadastroReceitaState createState() => _CadastroReceitaState();
}

class _CadastroReceitaState extends State<CadastroReceita> {
  final _formKey = GlobalKey<FormState>();
  late String nome;
  String? imagem;
  late String passos;
  late String ingredientes;
  CategoriaReceita categoria = CategoriaReceita.sobremesa;

  @override
  void initState() {
    super.initState();
    if (widget.receita != null) {
      nome = widget.receita!.nome;
      imagem = widget.receita!.imagem;
      passos = widget.receita!.passos;
      ingredientes = widget.receita!.ingredientes;
      categoria = CategoriaReceita.values.firstWhere(
              (e) => e.toShortString() == widget.receita!.categoria);
    } else {
      nome = '';
      passos = '';
      ingredientes = '';
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagem = pickedFile.path;
      });
    }
  }

  ReceitaDatabase receitaDatabase = ReceitaDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Easy Cook'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Container(
            color: Colors.purple,
            height: 4.0,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.receita == null ? 'Adicionar Receita' : 'Editar Receita',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                initialValue: nome,
                decoration: InputDecoration(
                  labelText: 'Nome da Receita',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome';
                  }
                  return null;
                },
                onSaved: (value) => nome = value!,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<CategoriaReceita>(
                value: categoria,
                items: CategoriaReceita.values
                    .map((cat) => DropdownMenuItem(
                  value: cat,
                  child: Text(cat.toShortString()),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    categoria = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: pickImage,
                child: Text('Selecionar Imagem'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
              ),
              if (imagem != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Image.file(File(imagem!), height: 100),
                ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: ingredientes,
                decoration: InputDecoration(
                  labelText: 'Ingredientes',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira os ingredientes';
                  }
                  return null;
                },
                onSaved: (value) => ingredientes = value!,
              ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: passos,
                decoration: InputDecoration(
                  labelText: 'Passos',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira os passos';
                  }
                  return null;
                },
                onSaved: (value) => passos = value!,
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      final novaReceita = Receita(
                        id: widget.receita?.id,
                        nome: nome,
                        imagem: imagem,
                        passos: passos,
                        ingredientes: ingredientes,
                        categoria: categoria.toShortString(),
                      );

                      if (widget.receita == null) {
                        receitaDatabase.create(novaReceita);
                      } else {
                        receitaDatabase.update(novaReceita);
                      }

                      Navigator.of(context).pop(novaReceita);
                    }
                  },
                  child: Text(widget.receita == null ? 'Salvar Receita' : 'Atualizar Receita'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}