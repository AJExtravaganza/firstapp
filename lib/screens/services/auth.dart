import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<FirebaseUser> get activeUser {
    return _auth.onAuthStateChanged;
  }

  Future signInAnonymously() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      print('Signed in anonymously as user "${result.user.uid}"');
      return user;
    } catch (e) {
      throw AuthException(null, "Anonymous authentication failed: ${e.toString()}");
    }
  }

//  email signin

//email register

  Future signOut() async {
    await _auth.signOut();
  }
}
