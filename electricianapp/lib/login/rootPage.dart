import 'package:electricianapp/Screens/screenDecider.dart';
import 'package:electricianapp/login/userProvider.dart';
import 'package:electricianapp/services/constant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'mainLogin.dart';

//Wrote by amanv8060

class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserRepository>(
      builder: (context, user, _) {
        switch (user.status) {
          case Status.Uninitialized:
            return buildWaitingScreen(context);
            break;
          case Status.Unauthenticated:
            return MainLogin();
            break;
          case Status.Authenticating:
            return MainLogin();
            break;
          case Status.Authenticated:
            {
              return Decider();
            }
            break;
          default:
            return MainLogin();
        }
      },
    );
  }
}
