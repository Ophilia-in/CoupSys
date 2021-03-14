import 'package:dealerapp/login/userProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class MainLogin extends StatefulWidget {
  @override
  _MainLoginState createState() => _MainLoginState();
}

class _MainLoginState extends State<MainLogin> {
  bool _isBusy = false;
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          Stack(
            children: [
              Container(
                height: _height,
                width: _width,
                child: Lottie.asset("assets/bulb2.json",
                    fit: BoxFit.cover, repeat: false),
              ),
              Container(
                height: _height,
                width: _width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
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
                    ),
                    SizedBox(
                      height: _height / 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SizedBox(
                        //   width: _width / 10,
                        // ),
                        Text(
                          "Login/SignUp With",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: _height / 35,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                _width / 9, 0, _width / 9, 0),
                            child: MaterialButton(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              onPressed: () async {
                                setState(
                                  () {
                                    _isBusy = true;
                                    _index = 1;
                                  },
                                );
                                user.googleSignIn().then((value) {
                                  if (value != null) {
                                  } else {
                                    setState(() {
                                      _isBusy = false;
                                      _index = 0;
                                    });
                                  }
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Image(
                                        image: AssetImage(
                                            "assets/google_logo.png"),
                                        height: 35.0),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        'Google',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: _height / 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
          _showCircularProgress(),
        ],
      ),
    );
  }

  Widget _showCircularProgress() {
    if (_isBusy) {
      return Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: Lottie.asset(
            "assets/bulb.json",
          ));
    } else
      return Container(
        height: 0.0,
        width: 0.0,
      );
  }
}
