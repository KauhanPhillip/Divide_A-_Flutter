class UserModel {
  final String id; // UUID no seu banco, tratamos como String no Flutter
  final String nome;
  final String email;
  final String? fotoUrl;

  UserModel({
    required this.id,
    required this.nome,
    required this.email,
    this.fotoUrl,
  });

  // Converte o JSON da API para o objeto UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      fotoUrl: json['foto_url'], // Nome do campo exatamente como no FastAPI
    );
  }

  // Converte o objeto UserModel para JSON (útil para cadastros/edições)
  Map<String, dynamic> toJson() {
    return {'id': id, 'nome': nome, 'email': email, 'foto_url': fotoUrl};
  }
}
