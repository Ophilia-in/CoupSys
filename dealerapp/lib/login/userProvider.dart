import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dealerapp/services/constant.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserRepository with ChangeNotifier {
  FirebaseAuth _auth;
  User _user;
  Status _status = Status.Uninitialized;

  UserRepository() {
    _auth = FirebaseAuth.instance;
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Status get status => _status;
  User get user => _user;

//Signs Out the Current User
  Future signOut() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  //returns the Current user  , null if no user is signed in
  Future<User> getCurrentUser() async {
    User user = _auth.currentUser;
    return user;
  }

  //Used for Signing in through Google
  Future<User> googleSignIn() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.disconnect();
    }
    try {
      _status = Status.Authenticating;
      notifyListeners();
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      await FirebaseAuth.instance.signInWithCredential(credential);
      return FirebaseAuth.instance.currentUser;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return null;
    }
  }

  Future<void> _onAuthStateChanged(User user) async {
    if (user == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = user;
      await loginCallback();
      _status = Status.Authenticated;
    }
    notifyListeners();
  }
}
