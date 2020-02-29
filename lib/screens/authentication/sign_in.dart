import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstapp/screens/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        elevation: 0.0,
        title: Text('Sign in to TeaVault'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: RaisedButton(
          child: Text('Sign In Anonymously'),
          onPressed: () async {
            try {
              print('Attempting anonymous sign-in');
              FirebaseUser user = await _authService.signInAnonymously();
            } catch(err) {
              print(err);
            }

            print('Anonymous sign-in successful');
          },
        )
      ),
    );
  }
}
