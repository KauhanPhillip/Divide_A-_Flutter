import 'package:flutter/material.dart';
import 'package:divide_ai_front/services/auth_service.dart';
import 'package:divide_ai_front/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  // Login
  Future<bool> login(String email, String senha) async {
    _isLoading = true;
    notifyListeners();

    final success = await _authService.login(email, senha);

    if (success) {
      // Aqui você pode atualizar o usuário com dados retornados pela API se desejar
      _user = UserModel(id: "1", nome: "Usuário", email: email);
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  // Cadastro (NOVO)
  Future<bool> cadastrar(String nome, String email, String senha) async {
    _isLoading = true;
    notifyListeners();

    final success = await _authService.cadastrar(nome, email, senha);

    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }
}
