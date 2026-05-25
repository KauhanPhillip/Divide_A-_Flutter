import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:divide_ai_front/models/grupo_model.dart';

class GrupoService {
  final String _baseUrl = 'https://divide-ai-6nxp.onrender.com';
  final _storage = const FlutterSecureStorage();

  Future<List<GrupoModel>> listarGrupos() async {
    final token = await _storage.read(key: 'jwt_token');
    final response = await http.get(
      Uri.parse('$_baseUrl/grupos'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => GrupoModel.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar grupos: ${response.statusCode}');
    }
  }

  Future<void> criarGrupo(String nome) async {
    final token = await _storage.read(key: 'jwt_token');
    final response = await http.post(
      Uri.parse('$_baseUrl/grupos/'), // Verifique se a rota na sua API é esta
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'nome': nome}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Falha ao criar grupo: ${response.statusCode}');
    }
  }
}
