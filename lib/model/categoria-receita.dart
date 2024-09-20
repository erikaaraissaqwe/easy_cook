enum CategoriaReceita {
  sobremesa,
  principal,
  entrada,
  bebida
}

extension ParseToString on CategoriaReceita {
  String toShortString() {
    return toString().split('.').last.toUpperCase();
  }
}
