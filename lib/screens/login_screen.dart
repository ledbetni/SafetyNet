import 'package:flutter/material.dart';
import 'package:safetynet/models/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Stack(children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(right: 100.0),
              child: Text('SafetyNet'),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Image.asset(
                'assets/icons8-business-network-64.png',
                width: 36,
                height: 28,
                fit: BoxFit.contain,
              ),
            ),
          )
        ]),
        centerTitle: true,
      ),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  final user = await createUser(
                      _emailController.text, _passwordController.text);
                  if (user != null) {
                    print('User signed up: ${user.email}');
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Sign Up'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final user = await signIn(
                      _emailController.text, _passwordController.text);
                  if (user != null) {
                    print('User signed in: ${user.email}');
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Sign In'),
              ),
            ],
          )),
    );
  }
}
