import 'package:firebase_auth/firebase_auth.dart';

Future<User?> createUser(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<User?> signIn(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
}
