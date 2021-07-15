import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> registerUser(String email, String password) async {
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    User? user = credential.user;

    return user;
  }

  Future<User?> loginUser(String email, String password) async {
    UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    User? user = credential.user;

    return user;
  }
}
