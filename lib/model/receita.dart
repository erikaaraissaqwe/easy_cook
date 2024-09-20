class Receita {
  int? id;
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
      'id': id,
      'nome': nome,
      'imagem': imagem,
      'passos': passos,
      'ingredientes': ingredientes,
      'categoria': categoria,
    };
  }

  factory Receita.fromMap(Map<String, dynamic> map) {
    return Receita(
      id: map['id'],
      nome: map['nome'],
      imagem: map['imagem'],
      passos: map['passos'],
      ingredientes: map['ingredientes'],
      categoria: map['categoria'],
    );
  }

  Receita copyWith({
    int? id,
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
