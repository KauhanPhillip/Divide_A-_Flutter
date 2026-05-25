import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:divide_ai_front/providers/auth_provider.dart';
import 'package:divide_ai_front/providers/grupo_provider.dart';
import 'package:divide_ai_front/screens/login_screen.dart';
import 'package:divide_ai_front/screens/criar_grupo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Carrega os grupos assim que a tela for exibida
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GrupoProvider>().carregarGrupos();
    });
  }

  @override
  Widget build(BuildContext context) {
    // O 'watch' faz a tela reconstruir automaticamente se os dados mudarem
    final grupoProvider = context.watch<GrupoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Grupos"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      // Botão flutuante para criar novos grupos
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CriarGrupoScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: grupoProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : grupoProvider.grupos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Nenhum grupo encontrado."),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CriarGrupoScreen(),
                        ),
                      );
                    },
                    child: const Text("Criar seu primeiro grupo"),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: grupoProvider.grupos.length,
              itemBuilder: (context, index) {
                final grupo = grupoProvider.grupos[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.group, color: Colors.deepPurple),
                    title: Text(grupo.nome),
                    subtitle: Text("ID do grupo: ${grupo.id}"),
                  ),
                );
              },
            ),
    );
  }
}
