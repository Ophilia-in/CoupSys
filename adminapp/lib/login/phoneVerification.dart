// import 'package:adminapp/login/rootPage.dart';
// import 'package:adminapp/login/userProvider.dart';
// import 'package:adminapp/main.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:adminapp/rest/constant.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:provider/provider.dart';

// class PhoneVerification extends StatefulWidget {
//   @override
//   _PhoneVerificationState createState() => _PhoneVerificationState();
// }

// class _PhoneVerificationState extends State<PhoneVerification> {
//   final _formKey = new GlobalKey<FormState>();

//   FirebaseAuth _auth = FirebaseAuth.instance;
//   String phone;
//   String authError = "";
//   String error = "";
//   bool visible = false;
//   final _codeController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<UserRepository>(context, listen: false);
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.cyan,
//           title: Text("Link Phone Number"),
//           actions: [
//             FlatButton(
//               child: Text("LogOut"),
//               onPressed: () {
//                 user.signOut();

//                 Navigator.of(context).pushAndRemoveUntil(
//                     MaterialPageRoute(builder: (context) => RootPage()),
//                     (route) => false);
//                 // Navigator.of(context).pop();
//                 // widget.logoutCallback();
//               },
//             )
//           ],
//         ),
//         body: SingleChildScrollView(
//           child: Container(
//             padding: EdgeInsets.all(32),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   FittedBox(
//                     fit: BoxFit.contain,
//                     child: Text(
//                       "Enter Phone Number",
//                       style: TextStyle(
//                           color: Colors.cyan,
//                           fontSize: 36,
//                           fontWeight: FontWeight.w500),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 16,
//                   ),
//                   IntlPhoneField(
//                     decoration: InputDecoration(
//                       errorText: error == "" ? null : error,
//                       labelText: 'Phone Number',
//                       border: OutlineInputBorder(
//                         borderSide: BorderSide(),
//                       ),
//                     ),
//                     onChanged: (value) {
//                       if (value.number.length != 10 ||
//                           int.tryParse(value.number) == null) {
//                         setState(() {
//                           error = "Invalid Number";
//                         });
//                       } else {
//                         setState(() {
//                           error = "";
//                         });
//                       }
//                     },
//                     onSaved: (newValue) {
//                       setState(() {
//                         phone = newValue.completeNumber;
//                       });
//                     },
//                     initialCountryCode: 'IN', //Update Later
//                   ),
//                   SizedBox(
//                     height: 16,
//                   ),
//                   Container(
//                     width: double.infinity,
//                     child: FlatButton(
//                       disabledColor: Colors.red,
//                       child: Text("Continue"),
//                       textColor: Colors.white,
//                       padding: EdgeInsets.all(16),
//                       onPressed: error == ""
//                           ? () {
//                               setState(() {
//                                 authError = "";
//                               });
//                               _formKey.currentState.save();
//                               print(phone);
//                               loginUser(phone, context);
//                             }
//                           : null,
//                       color: Colors.cyan,
//                     ),
//                   ),
//                   Visibility(
//                       visible: authError != "" || authError != null,
//                       child: Text(authError))
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }


//   Future<void> loginUser(String phone, BuildContext context) async {
//     _auth.verifyPhoneNumber(
//         phoneNumber: phone,
//         timeout: Duration(seconds: 60),
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           Navigator.of(context).pop();
//           // print(credential.smsCode);
//           _auth.currentUser.updatePhoneNumber(credential).then((value) async {
//             if (_auth.currentUser.phoneNumber != null) {
//               await loginCallback().then((val) => Navigator.pushAndRemoveUntil(
//                   context,
//                   CupertinoPageRoute(builder: (context) => RootPage()),
//                   (route) => false));
//               // Navigator.pushReplacement(
//               //     context, MaterialPageRoute(builder: (context) => MyApp()));
//             }
//           }).catchError((err) {
//             print(err.toString());
//             if (err.code == "credential-already-in-use") {
//               setState(() {
//                 authError =
//                     "Phone No Already registered with different account";
//               });
//             } else {
//               setState(() {
//                 authError = err.toString();
//               });
//             }
//           });
//         },
//         verificationFailed: (FirebaseAuthException exception) {
//           if (exception.code == "credential-already-in-use") {
//             setState(() {
//               authError = "Phone No Already registered with different account";
//             });
//           } else {
//             print(exception.message.toString());
//             setState(() {
//               authError = exception.code;
//             });
//           }
//         },
//         codeSent: (String verificationId, [int forceResendingToken]) {
//           showModalBottomSheet(
//               isDismissible: false,
//               context: context,
//               builder: (context) {
//                 return Container(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Enter Otp",
//                           style: Theme.of(context).textTheme.headline5),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       TextField(
//                         decoration: InputDecoration(
//                             border:
//                                 OutlineInputBorder(borderSide: BorderSide())),
//                         controller: _codeController,
//                       ),
//                       authError == ""
//                           ? SizedBox(
//                               height: 0,
//                             )
//                           : Text(authError),
//                       FlatButton(
//                         child: Text("Confirm"),
//                         textColor: Colors.white,
//                         color: Colors.blue,
//                         onPressed: () async {
//                           final code = _codeController.text.trim();
//                           final credential = PhoneAuthProvider.credential(
//                               verificationId: verificationId, smsCode: code);
//                           await FirebaseAuth.instance.currentUser
//                               .updatePhoneNumber(credential)
//                               .then((value) async {
//                             if (_auth.currentUser.phoneNumber != null ||
//                                 _auth.currentUser.phoneNumber != "") {
//                               // setState(() {
//                               //   authError = "";
//                               // });
//                               // Navigator.of(context).pop();

//                               await loginCallback().then((value) =>
//                                   Navigator.of(context).pushAndRemoveUntil(
//                                       CupertinoPageRoute(
//                                           builder: (context) => RootPage()),
//                                       (route) => false));
//                             } else {
//                               Navigator.pop(context);
//                             }
//                           }).catchError((err) {
//                             if (err.code == "credential-already-in-use") {
//                               setState(() {
//                                 authError =
//                                     "Phone No Already registered with different account";
//                               });
//                               Navigator.of(context).pop();
//                             } else if (err.code ==
//                                 "invalid-verification-code") {
//                               setState(() {
//                                 authError = "Incorrect Otp";
//                               });
//                               Navigator.of(context).pop();
//                             } else {
//                               setState(() {
//                                 _codeController.clear();
//                                 authError = err.code.toString();
//                               });
//                               Navigator.of(context).pop();
//                             }
//                           });
//                         },
//                       )
//                     ],
//                   ),
//                 );
//               });
//           // showDialog(
//           //     context: context,
//           //     barrierDismissible: false,
//           //     child:
//           //      AlertDialog(
//           //       title: Text("Enter Otp"),
//           //       content: Column(
//           //         mainAxisSize: MainAxisSize.min,
//           //         children: [
//           //           TextField(
//           //             decoration: InputDecoration(
//           //                 border: OutlineInputBorder(borderSide: BorderSide())),
//           //             controller: _codeController,
//           //           ),
//           //           authError == ""
//           //               ? SizedBox(
//           //                   height: 0,
//           //                 )
//           //               : Text(authError)
//           //         ],
//           //       ),
//           //       actions: <Widget>[
//           //         FlatButton(
//           //           child: Text("Confirm"),
//           //           textColor: Colors.white,
//           //           color: Colors.blue,
//           //           onPressed: () {
//           //             final code = _codeController.text.trim();
//           //             final credential = PhoneAuthProvider.credential(
//           //                 verificationId: verificationId, smsCode: code);
//           //             FirebaseAuth.instance.currentUser
//           //                 .updatePhoneNumber(credential)
//           //                 .whenComplete(() async {
//           //               if (_auth.currentUser.phoneNumber != null ||
//           //                   _auth.currentUser.phoneNumber != "") {
//           //                 // setState(() {
//           //                 //   authError = "";
//           //                 // });
//           //                 Navigator.of(context).pop();

//           //                 loginCallback().whenComplete(() =>
//           //                     Navigator.pushAndRemoveUntil(
//           //                         context,
//           //                         CupertinoPageRoute(
//           //                             builder: (context) => MyApp()),
//           //                         (route) => false));
//           //               } else {
//           //                 Navigator.of(context).pop();
//           //               }
//           //             }).catchError((err) {
//           //               if (err.code == "credential-already-in-use") {
//           //                 setState(() {
//           //                   authError =
//           //                       "Phone No Already registered with different account";
//           //                 });
//           //                 Navigator.of(context).pop();
//           //               } else if (err.code == "invalid-verification-code") {
//           //                 setState(() {
//           //                   authError = "Incorrect Otp";
//           //                 });
//           //                 // Navigator.of(context, rootNavigator: true)
//           //                 //     .pop();
//           //                 Navigator.of(context).pop();
//           //               } else {
//           //                 setState(() {
//           //                   _codeController.clear();
//           //                   authError = err.code.toString();
//           //                 });
//           //                 Navigator.of(context).pop();
//           //               }
//           //             });
//           //           },
//           //         )
//           //       ],
//           //     ));
//         },
//         codeAutoRetrievalTimeout: (String abc) {
//           Fluttertoast.showToast(msg: "Otp Timed Out , Retry!!");
//         });
//   }
// }
