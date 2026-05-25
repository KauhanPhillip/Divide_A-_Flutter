import 'package:flutter/material.dart';
import 'package:divide_ai_front/models/grupo_model.dart';
import 'package:divide_ai_front/services/grupo_service.dart';

class GrupoProvider with ChangeNotifier {
  final GrupoService _service = GrupoService();
  List<GrupoModel> _grupos = [];
  bool _isLoading = false;

  List<GrupoModel> get grupos => _grupos;
  bool get isLoading => _isLoading;

  Future<void> carregarGrupos() async {
    _isLoading = true;
    notifyListeners();
    try {
      _grupos = await _service.listarGrupos();
    } catch (e) {
      print("Erro ao carregar grupos: $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> adicionarGrupo(String nome) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _service.criarGrupo(nome);
      await carregarGrupos(); // Recarrega a lista após criar
      return true;
    } catch (e) {
      debugPrint("Erro ao criar: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
