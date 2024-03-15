import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safetynet/lib.dart';
import 'package:safetynet/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoggedIn = false;
  bool _someSwitchValue = false;

  void _navigateToLoginScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: ((context) => LoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('Settings'),
        // ),
        body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Something went wrong!'),
          );
        } else if (snapshot.hasData) {
          User user = snapshot.data!;

          return ListView(
            padding: EdgeInsets.all(16.0),
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.email),
                title: Text(user.email ?? 'No email'),
              ),
              ElevatedButton(
                  onPressed: () async {
                    signOut();
                  },
                  child: Text('Log Out'))
            ],
          );
        } else {
          return Column(children: <Widget>[
            SizedBox(
              height: 200,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                  'Log in or create an account to access features such as cloud storage'),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () => _navigateToLoginScreen(context),
                child: Text('Log In'),
              ),
            ),
          ]);
        }
      },
    ));
  }
}
