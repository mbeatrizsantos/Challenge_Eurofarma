import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Função de login com e-mail e senha
  static Future<String?> loginWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // sucesso
    } on FirebaseAuthException catch (e) {
      return e.message; // erro
    } catch (e) {
      return "Erro inesperado: $e";
    }
  }

  // Função de logout (opcional)
  static Future<void> logout() async {
    await _auth.signOut();
  }

  // Pega o usuário atual
  static User? get currentUser => _auth.currentUser;
}
