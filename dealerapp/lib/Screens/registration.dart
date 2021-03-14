import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dealerapp/Screens/screenDecider.dart';
import 'package:dealerapp/login/rootPage.dart';
import 'package:dealerapp/login/userProvider.dart';
import 'package:dealerapp/models/userModel.dart';
import 'package:dealerapp/services/constant.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Registration extends StatefulWidget {
  Registration({Key key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  MyUser myUser = Hive.box<MyUser>(userBox).get("myuser");
  bool _isbusy = false;
  List<Object> images = List<Object>();
  int _count = 0;
  ImagePicker _picker = ImagePicker();
  String _type = "Retailer";
  TextEditingController _firmName = TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {
      images.add("Add Image");
      images.add("Add Image");
      images.add("Add Image");
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Continue Registration"),
        actions: [
          FlatButton(
            child: Text("LogOut"),
            onPressed: () {
              user.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => RootPage()),
                  (route) => false);
            },
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: Colors.black, width: 3)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Select Account Type : ",
                          style: sheettext,
                        ),
                        DropdownButton(
                            isDense: true,
                            value: _type,
                            items: ["Retailer", "Dealer"]
                                .map((e) => DropdownMenuItem(
                                      child: Text(e),
                                      value: e,
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _type = value;
                              });
                            }),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Enter Firm Name",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _firmName,
                      validator: (String value) {
                        if (value.length < 5) {
                          return "Too Short";
                        } else
                          return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Enter Firm Name",
                        labelText: "Firm Name",
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 3.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 3.0),
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 2)),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          Text(
                            "Upload 3 ID Proofs ",
                            style: sheettext,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          buildGridView(),
                        ],
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: FlatButton(
                      onPressed: (_count == 3 && _firmName.text.length >= 5)
                          ? () {
                              uploadFile(context);
                            }
                          : null,
                      disabledColor: Colors.red,
                      child: Text("Continue "),
                      color: Colors.green,
                    ),
                  ),
                  _count == 3
                      ? SizedBox(
                          height: 0,
                        )
                      : Text(
                          "Attach 3 images ",
                          style: TextStyle(color: Colors.red),
                        ),
                  ListTile(
                    title: Text("Following Images should be added"),
                    isThreeLine: true,
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("1. Aadhar"),
                        Text("2. Business Proof"),
                        Text("3. A Photograpgh of Self"),
                      ],
                    ),
                  )
                ],
              )),
          _isbusy
              ? buildWaitingScreen()
              : SizedBox(
                  height: 0,
                )
        ],
      ),
    );
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
          // color: Colors.green,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: Lottie.asset("assets/bulb.json")),
    );
  }

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 1,
      children: List.generate(images.length, (index) {
        if (images[index] is ImageUploadModel) {
          ImageUploadModel uploadModel = images[index];
          return Card(
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.black, width: 3),
                borderRadius: BorderRadius.circular(12)),
            // borderOnForeground: true,
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: <Widget>[
                Image.file(
                  File(uploadModel.imageFile.path),
                  width: 300,
                  height: 300,
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: InkWell(
                    child: Icon(
                      Icons.remove_circle,
                      size: 20,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        images.replaceRange(index, index + 1, ['Add Image']);
                        _count = _count - 1;
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container(
            child: Card(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.deepPurple, width: 3),
                  borderRadius: BorderRadius.circular(12)),
              borderOnForeground: true,
              child: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _onAddImageClick(index);
                  }),
            ),
          );
        }
      }),
    );
  }

  Future uploadFile(BuildContext context) async {
    List<dynamic> templist = List<String>();
    StorageReference reference = FirebaseStorage.instance.ref();
    setState(() {
      _isbusy = true;
    });
    for (int i = 1; i <= 3; i++) {
      if (images[i - 1] is ImageUploadModel) {
        ImageUploadModel temp = images[i - 1];
        File file = File(temp.imageFile.path);
        String fileName = myUser.uid + i.toString();
        final ref = reference.child(fileName);
        StorageUploadTask uploadTask = ref.putFile(file);
        StorageTaskSnapshot storageTaskSnapshot;
        await uploadTask.onComplete.then((value) async {
          if (value.error == null) {
            // value.ref.getDownloadURL().
            storageTaskSnapshot = value;
            await storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
              templist.add(downloadUrl);
            }, onError: (err) {
              Fluttertoast.showToast(
                  msg: 'Number ${i + 1} file is not an image',
                  toastLength: Toast.LENGTH_LONG);
            });
          } else {
            Fluttertoast.showToast(
                msg: 'This file is not an image',
                toastLength: Toast.LENGTH_LONG);
          }
        }, onError: (err) {
          Fluttertoast.showToast(
              msg: err.toString(), toastLength: Toast.LENGTH_LONG);
        });
      } else {
        setState(() {
          _isbusy = false;
        });
        Fluttertoast.showToast(
            msg: "Attached File are not Images , or some error occured");
        return;
      }
    }

    await FirebaseFirestore.instance
        .collection('Member')
        .doc(myUser.uid)
        .update({
      'ids': templist,
      'firmName': _firmName.text,
      'reason': "Waiting For Approval",
      'accountType': _type
    }).then((data) async {
      // Navigator.pop(context);
      myUser..ids = templist;
      myUser..reason = "Waiting For Approval";
      update(myUser);
      setState(() {
        _isbusy = false;
      });
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => Decider()), (route) => false);
      Fluttertoast.showToast(msg: "Upload and Sccess");
    }).catchError((err) {
      setState(() {
        _isbusy = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });

    // List<dynamic> templist = List<String>();
    // firebase_storage.Reference reference =
    //     firebase_storage.FirebaseStorage.instance.ref();
    // setState(() {
    //   _isbusy = true;
    // });
    // for (int i = 1; i <= 3; i++) {
    //   if (images[i - 1] is ImageUploadModel) {
    //     ImageUploadModel temp = images[i - 1];
    //     File file = File(temp.imageFile.path);
    //     String fileName = myUser.uid + i.toString();
    //     final ref = reference.child(fileName);
    //     firebase_storage.UploadTask uploadTask = ref.putFile(file);
    //     firebase_storage.TaskSnapshot storageTaskSnapshot;
    //     await uploadTask.then((value) async {
    //       if (value != null) {
    //         // value.ref.getDownloadURL().
    //         storageTaskSnapshot = value;
    //         await storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
    //           templist.add(downloadUrl);
    //         }, onError: (err) {
    //           Fluttertoast.showToast(
    //               msg: 'Number ${i + 1} file is not an image',
    //               toastLength: Toast.LENGTH_LONG);
    //         });
    //       } else {
    //         Fluttertoast.showToast(
    //             msg: 'This file is not an image',
    //             toastLength: Toast.LENGTH_LONG);
    //       }
    //     }, onError: (err) {
    //       Fluttertoast.showToast(
    //           msg: err.toString(), toastLength: Toast.LENGTH_LONG);
    //     });
    //   } else {
    //     setState(() {
    //       _isbusy = false;
    //     });
    //     Fluttertoast.showToast(
    //         msg: "Attached File are not Images , or some error occured");
    //     return;
    //   }
    // }
    //
    // await FirebaseFirestore.instance
    //     .collection('Member')
    //     .doc(myUser.uid)
    //     .update({
    //   'ids': templist,
    //   'firmName': _firmName.text,
    //   'reason': "Waiting For Approval",
    //   'accountType': _type
    // }).then((data) async {
    //   // Navigator.pop(context);
    //   myUser..ids = templist;
    //   myUser..reason = "Waiting For Approval";
    //   update(myUser);
    //   setState(() {
    //     _isbusy = false;
    //   });
    //   Navigator.pushAndRemoveUntil(context,
    //       MaterialPageRoute(builder: (context) => Decider()), (route) => false);
    //   Fluttertoast.showToast(msg: "Upload and Sccess");
    // }).catchError((err) {
    //   setState(() {
    //     _isbusy = false;
    //   });
    //   Fluttertoast.showToast(msg: err.toString());
    // });
  }

  Future _onAddImageClick(int index) async {
    PickedFile abc;
   
    try {
      abc = await _picker.getImage(source: ImageSource.gallery);

      
      if (abc == null) {
        Fluttertoast.showToast(msg: "You did not select Picture");
        return;
      }
      setState(() {
        ImageUploadModel imageUpload = ImageUploadModel(
            isUploaded: false, uploading: false, imageFile: abc, imageUrl: '');
        // imageUpload.isUploaded = false;
        // imageUpload.uploading = false;
        // imageUpload.imageFile = abc;
        // imageUpload.imageUrl = '';
        images.replaceRange(index, index + 1, [imageUpload]);
        _count += 1;
      });
    } catch (e) {
      return;
    }
  }
}

void update(MyUser obj) async {
  await Hive.box<MyUser>(userBox).put("myuser", obj);
}

class ImageUploadModel {
  bool isUploaded;
  bool uploading;
  PickedFile imageFile;
  String imageUrl;

  ImageUploadModel({
    this.isUploaded,
    this.uploading,
    this.imageFile,
    this.imageUrl,
  });
}
