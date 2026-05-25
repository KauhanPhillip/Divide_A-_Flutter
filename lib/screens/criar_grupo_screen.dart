import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:divide_ai_front/providers/grupo_provider.dart';

class CriarGrupoScreen extends StatefulWidget {
  const CriarGrupoScreen({super.key});

  @override
  State<CriarGrupoScreen> createState() => _CriarGrupoScreenState();
}

class _CriarGrupoScreenState extends State<CriarGrupoScreen> {
  final _nomeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final grupoProvider = context.watch<GrupoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Novo Grupo"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Dê um nome para o seu grupo de divisas:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: "Ex: Viagem de Férias, Aluguel...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: grupoProvider.isLoading
                  ? null
                  : () async {
                      final nome = _nomeController.text.trim();
                      if (nome.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("O nome não pode ser vazio!"),
                          ),
                        );
                        return;
                      }

                      final sucesso = await context
                          .read<GrupoProvider>()
                          .adicionarGrupo(nome);

                      if (sucesso && context.mounted) {
                        Navigator.pop(context); // Volta para a Home
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Grupo criado com sucesso!"),
                          ),
                        );
                      }
                    },
              child: grupoProvider.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("CRIAR GRUPO", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }
}
