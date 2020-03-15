import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstapp/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'authenticate.dart';

//Serves sign-in screen when not logged in, and listens to changes in authentication state
class AuthenticationWrapper extends StatelessWidget {
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final activeUser = Provider.of<FirebaseUser>(context);
//    if (activeUser != null) {
//      print('Got activeUser "${activeUser.uid}" from auth stream');
//    } else {
//      print('No activeUser');
//    }

    if (activeUser != null) {
//      print('Displaying home screen');
      return this.child;
    } else {
//      print('Displaying sign-in screen');
      return Authenticate();
    }
  }

  AuthenticationWrapper(this.child);
}
