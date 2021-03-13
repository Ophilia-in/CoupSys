import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:adminapp/services/constant.dart';

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

  //Used for Signing in through Email
  Future<User> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();

      UserCredential _returnedUser = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return _returnedUser.user;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      throw e;
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
