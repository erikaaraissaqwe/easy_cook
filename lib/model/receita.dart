import 'package:cloud_firestore/cloud_firestore.dart';

class Receita {
  String? id;
  String nome;
  String? imagem;
  String passos;
  String ingredientes;
  String categoria;

  Receita({
    this.id,
    required this.nome,
    this.imagem,
    required this.passos,
    required this.ingredientes,
    required this.categoria,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'imagem': imagem,
      'passos': passos,
      'ingredientes': ingredientes,
      'categoria': categoria,
    };
  }

  factory Receita.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Receita(
      id: doc.id,
      nome: data['nome'] ?? '',
      imagem: data['imagem'],
      passos: data['passos'] ?? '',
      ingredientes: data['ingredientes'] ?? '',
      categoria: data['categoria'] ?? '',
    );
  }

  Receita copyWith({
    String? id,
    String? nome,
    String? imagem,
    String? passos,
    String? ingredientes,
    String? categoria,
  }) {
    return Receita(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      imagem: imagem ?? this.imagem,
      passos: passos ?? this.passos,
      ingredientes: ingredientes ?? this.ingredientes,
      categoria: categoria ?? this.categoria,
    );
  }
}
