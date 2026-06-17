import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  Future<String?> signIn() async {
    try {
      await GoogleSignIn.instance.initialize();
      final account = await GoogleSignIn.instance.authenticate();
      return account.email;
    } catch (error) {
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
  }
}
