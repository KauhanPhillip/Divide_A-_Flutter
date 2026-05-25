import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:divide_ai_front/providers/auth_provider.dart';
import 'package:divide_ai_front/screens/login_screen.dart';
import 'package:divide_ai_front/screens/home_screen.dart';
import 'package:divide_ai_front/providers/grupo_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => GrupoProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Função que checa se o token existe no armazenamento seguro
  Future<bool> _verificarToken() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt_token');
    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Divide Aí',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: _verificarToken(),
        builder: (context, snapshot) {
          // Mostra um carregando enquanto checa o token
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          // Se o token existe, manda pra Home, se não, pro Login
          return snapshot.data == true
              ? const HomeScreen()
              : const LoginScreen();
        },
      ),
    );
  }
}
