class GrupoModel {
  final int id;
  final String nome;

  GrupoModel({required this.id, required this.nome});

  factory GrupoModel.fromJson(Map<String, dynamic> json) {
    return GrupoModel(id: json['id'], nome: json['nome']);
  }
}
