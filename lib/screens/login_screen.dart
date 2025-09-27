import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _loading = true);

      final result = await AuthService.loginWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      setState(() => _loading = false);

      if (result == null) {
        // Login bem-sucedido → vai para a HomeScreen
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // Adicionado AppBar para o botão de voltar e o título
        backgroundColor: Colors.transparent, // Transparente para o gradiente de fundo
        elevation: 0, // Sem sombra
      
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true, // Faz o body ir por trás da AppBar
      body: Container( // Adicionando o Container com o gradiente
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0C2462), // Cor inicial do seu design (um azul mais escuro)
              Color(0xFF0F4C81), // Cor final do seu design (um azul um pouco mais claro)
            ],
          ),
        ),
        child: SafeArea( // SafeArea para o conteúdo do formulário
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Image.asset('assets/logo.png', height: 120),
                    const SizedBox(height: 40),

                    _buildInputField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.person,
                      obscure: false,
                    ),
                    const SizedBox(height: 16),

                    _buildInputField(
                      controller: _passwordController,
                      label: 'Senha',
                      icon: Icons.lock,
                      obscure: true,
                    ),
                    const SizedBox(height: 24),

                    _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Container(
                            width: double.infinity,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF2D72FF),
                                  Color(0xFF0C47A1),
                                ],
                              ),
                            ),
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: const Text(
                                'Entrar',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool obscure,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      validator: (value) =>
          value!.isEmpty ? 'Informe seu ${label.toLowerCase()}' : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.black.withOpacity(0.5), // Ajustei a opacidade para combinar com a imagem
        hintText: label,
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}