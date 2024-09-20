import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_cook/repository/receita-database.dart';
import 'package:easy_cook/view/detalhes-receita.dart';
import 'package:easy_cook/model/receita.dart';

void main() {
  runApp(ReceitaApp());
}

class ReceitaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Cook',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: ListaReceitas(),
    );
  }
}

class ListaReceitas extends StatefulWidget {
  @override
  _ListaReceitasState createState() => _ListaReceitasState();
}

class _ListaReceitasState extends State<ListaReceitas> {
  late Future<List<Receita>> receitas;

  @override
  void initState() {
    super.initState();
    refreshReceitas();
  }

  void refreshReceitas() {
    setState(() {
      receitas = ReceitaDatabase.instance.readAllReceitas();
    });
  }

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Lista de Receitas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Receita>>(
              future: receitas,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final receitas = snapshot.data!;
                  return ListView.builder(
                    itemCount: receitas.length,
                    itemBuilder: (context, index) {
                      final receita = receitas[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(10),
                          leading: receita.imagem != null
                              ? Image.file(File(receita.imagem!), width: 50, height: 50)
                              : Icon(Icons.food_bank),
                          title: Text(
                            receita.nome,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(receita.categoria),
                          onTap: () async {
                            final updatedReceita = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => CadastroReceita(receita: receita),
                              ),
                            );
                            if (updatedReceita != null) {
                              refreshReceitas();
                            }
                          },
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              bool? confirmDelete = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Confirmar Exclusão'),
                                    content: Text('Tem certeza que deseja excluir esta receita?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                        child: Text('Excluir'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              if (confirmDelete == true) {
                                await ReceitaDatabase.instance.delete(receita.id!);
                                refreshReceitas();
                              }
                            },
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text('Nenhuma receita cadastrada'));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final novaReceita = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CadastroReceita(),
            ),
          );
          if (novaReceita != null) {
            refreshReceitas();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}