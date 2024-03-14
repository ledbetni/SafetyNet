import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safetynet/lib.dart';

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

Future<void> addUserToFirestore(User user) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'email': user.email,
    });
  } catch (e) {
    print('Error adding user to Firestore: $e');
  }
}

Future<User?> registerAndAddUser(String email, String password) async {
  User? newUser = await createUser(email, password);
  if (newUser != null) {
    await addUserToFirestore(newUser);
    return newUser;
  } else {
    print('User Registration Failed');
    return null;
  }
}
