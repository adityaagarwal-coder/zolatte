import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zolatte/pages/deleteUserData.dart';
import 'package:zolatte/pages/sign_in_page.dart';
import 'package:zolatte/utils/database.dart';
import 'package:zolatte/utils/fetchUserDetails.dart';
import 'package:zolatte/utils/googleSignIn.dart';
import 'package:zolatte/utils/validate.dart';
import 'package:zolatte/widgets/custom_textfield.dart';

final user = FirebaseAuth.instance.currentUser!;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  DatabaseServices databaseServices = new DatabaseServices();
  TextEditingController mobileController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  void initState() {
    super.initState();
    databaseServices
        .updateTask({"name": user.displayName, "emailId": user.email}, userid);
  }

  final List<String> items = ['10', '20', '30', '40', '50'];
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        drawer: Drawer(
          child: Column(
            children: [
              DrawerHeader(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black, Colors.grey])),
                  child: Container(
                    margin: EdgeInsets.only(top: 70),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            authMethod == "google"
                                ? CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                        NetworkImage(user.photoURL!))
                                : Container(),
                            SizedBox(width: 10),
                            authMethod == "google"
                                ? Text(user.displayName!,
                                    style: TextStyle(color: Colors.white))
                                : Container(),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Spacer(),
                            authMethod == "google"
                                ? Text(user.email!,
                                    style: TextStyle(color: Colors.white))
                                : Container()
                          ],
                        )
                      ],
                    ),
                  )),
              ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DeleteUserData()));
                  },
                  title: Text("Delete User Data from Firebase")),
              ListTile(
                  onTap: () {
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider.logout();
                  },
                  title: Text("LogOut"))
            ],
          ),
        ),
        body: Stack(children: [
          Container(
              height: 200,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.grey, Colors.black]),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100)))),
          Positioned(
              left: 100,
              top: 30,
              child: Text("User Details",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold))),
          fetchUserData(),
          Positioned(
              left: 10,
              top: 50,
              child: InkWell(
                onTap: () {
                  setState(() {
                    scaffoldKey.currentState!.openDrawer();
                  });
                },
                child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100)),
                    child: Center(child: Icon(Icons.menu))),
              )),
          Container(
            padding: EdgeInsets.only(top: 300),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text("Update User Details"),
                  CustomFormField(
                      controller: mobileController,
                      hintText: "Mobile",
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r"[0-9]"),
                        )
                      ],
                      validator: (val) {
                        if (!val!.isValidPhone) {
                          return 'Enter valid phone';
                        }
                      }),
                  CustomFormField(
                    controller: addressController,
                    hintText: "Address",
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      hint: Text(
                        'Select Age',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      items: items
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      value: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value as String;
                        });
                      },
                      buttonHeight: 40,
                      buttonWidth: 140,
                      itemHeight: 40,
                    ),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      databaseServices.updateTask({
                        "MobileNo": mobileController.text,
                        "Address": addressController.text,
                        "Age": selectedValue,
                      }, userid);
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text("Submit",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ]));
  }
}
