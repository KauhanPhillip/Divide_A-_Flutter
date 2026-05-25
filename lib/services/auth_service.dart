import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // URL única, centralizada
  final String _baseUrl = "https://divide-ai-6nxp.onrender.com";
  final _storage = const FlutterSecureStorage();

  // Login
  Future<bool> login(String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'senha': senha}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Salvamos o token no armazenamento seguro
        await _storage.write(key: 'jwt_token', value: data['access_token']);
        return true;
      }
      return false;
    } catch (e) {
      print("Erro ao tentar login: $e");
      return false;
    }
  }

  // Cadastro
  Future<bool> cadastrar(String nome, String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/usuarios/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"nome": nome, "email": email, "senha": senha}),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Erro ao cadastrar: $e");
      return false;
    }
  }

  // Logout - Remove o token do armazenamento seguro
  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }

  // Helper para recuperar o token (útil para futuras requisições protegidas)
  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }
}
