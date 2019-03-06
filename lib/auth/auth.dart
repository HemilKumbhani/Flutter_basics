import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  @override
  Future<String> signUp(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }
}
