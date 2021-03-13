import 'package:adminapp/login/userProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class MainLogin extends StatefulWidget {
  @override
  _MainLoginState createState() => _MainLoginState();
}

class _MainLoginState extends State<MainLogin> {
  final _formKey = new GlobalKey<FormState>();
  bool _isBusy;
  String _email;
  String _password;
  String _errorMessage;

  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _isBusy = false;
    _errorMessage = "";
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _showForm(_height, _width, user),
          _showCircularProgress(),
        ],
      ),
    );
  }

  Widget _showCircularProgress() {
    if (_isBusy) {
      return Container(
          color: Colors.white24,
          child: Center(child: CircularProgressIndicator()));
    } else
      return Container(
        height: 0.0,
        width: 0.0,
      );
  }

  // Check if form is valid before perform login or SignUp
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login
  void validateAndSubmit(UserRepository user) async {
    if (validateAndSave()) {
      setState(
        () {
          _errorMessage = "";
          _isBusy = true;
        },
      );
      try {
        await user.signIn(_email, _password);
      } catch (e) {
        setState(
          () {
            _isBusy = false;
            _errorMessage = e.message;
            resetForm();
          },
        );
      }
    } else {
      Fluttertoast.showToast(
          msg: "Fill Email/Password Properly",
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red);
    }
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(
      () {
        _email = null;
        _password = null;
      },
    );
  }

  Widget _showForm(final _height, final _width, UserRepository user) {
    return Container(
      padding: EdgeInsets.fromLTRB(_width / 20, 0, _width / 20, 0),
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: new Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                showLogo(_height, _width),
                showInput(_height, _width),
                showPrimaryButton(_height, user),
                showErrorMessage(_height),
              ],
            )),
      ),
    );
  }

  Widget showErrorMessage(final _height) {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return Container(
        height: _height / 6,
        child: new Text(
          _errorMessage,
          style: TextStyle(
              fontSize: 13.0,
              color: Colors.red,
              height: 1.0,
              fontWeight: FontWeight.w300),
        ),
      );
    } else {
      return new Container(
        height: _height / 6,
      );
    }
  }

  Widget showLogo(final _height, final _width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: _width / 1.5,
          height: _height / 3,
          child: Image.asset(
            "assets/logo.png",
            fit: BoxFit.fill,
          ),
        )
      ],
    );
  }

  Widget showInput(final height, final width) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.fromLTRB(width / 30, height / 10, width / 30, 0.0),
          child: TextFormField(
            maxLines: 1,
            keyboardType: TextInputType.emailAddress,
            autofocus: false,
            decoration: InputDecoration(
              hintText: 'Email',
              icon: Icon(
                Icons.mail,
                color: Colors.blue,
              ),
              border: OutlineInputBorder(borderSide: BorderSide()),
            ),
            validator: (value) => validateEmail(value),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) {
              setState(
                () {
                  _email = value.trim();
                },
              );
            },
          ),
        ),
        Padding(
          padding:
              EdgeInsets.fromLTRB(width / 30, height / 30, width / 30, 0.0),
          child: TextFormField(
            maxLines: 1,
            obscureText: !_showPassword,
            autofocus: false,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              hintText: 'Password',
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: !_showPassword ? Colors.blue : Colors.red,
                ),
                onPressed: () {
                  setState(
                    () {
                      this._showPassword = !this._showPassword;
                    },
                  );
                },
              ),
              icon: Icon(
                Icons.lock,
                color: Colors.blue,
              ),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => validatePassword(value),
            onChanged: (value) {
              setState(
                () {
                  _password = value.trim();
                },
              );
            },
          ),
        )
      ],
    );
  }

  Widget showPrimaryButton(final _height, UserRepository user) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, _height / 15, 0.0, 10.0),
      child: FlatButton(
          padding: EdgeInsets.only(left: 40, right: 40),
          disabledColor: Colors.red,
//            elevation: 5.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: Colors.blue,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Login',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: Colors.white)),
            ],
          ),
          onPressed: _email != null &&
                  _password != null &&
                  _email.length > 5 &&
                  _password.length >= 8
              ? () {
                  validateAndSubmit(user);
                }
              : null),
    );
  }

  String validateEmail(String value) {
    RegExp regExp = RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
    if (value.length == 0) {
      return 'Please enter Email Address';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid email Address';
    }
    return null;
  }

  String validatePassword(String value) {
    // RegExp regExp = RegExp(r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
    if (value.length == 0) {
      return 'Please enter Password';
    } else if (value.length < 8) {
      return 'Please enter Password of atleast 8 characters';
    }
    return null;
  }
}
