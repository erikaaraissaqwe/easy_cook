import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_cook/model/receita.dart';

class ReceitaDatabase {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Receita>> streamAllReceitas() {
    return _db.collection('receitas').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Receita.fromDocument(doc);
      }).toList();
    });
  }

  void create(Receita receita) {
    _db.collection('receitas').add(receita.toMap());
  }

  // Método para atualizar uma receita
  void update(Receita receita) {
    _db.collection('receitas').doc(receita.id).update(receita.toMap());
  }

  void delete(String receitaId) {
    _db.collection('receitas').doc(receitaId).delete();
  }
}