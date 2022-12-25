import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:zolatte/pages/Home.dart';
import 'package:zolatte/pages/sign_in_page.dart';
import 'package:zolatte/utils/database.dart';

class DeleteUserData extends StatefulWidget {
  const DeleteUserData({super.key});

  @override
  State<DeleteUserData> createState() => _DeleteUserDataState();
}

class _DeleteUserDataState extends State<DeleteUserData> {
  DatabaseServices databaseServices = new DatabaseServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Container(
          height: 200,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.grey, Colors.black]),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100)))),
      Positioned(
          left: 10,
          top: 50,
          child: InkWell(
            onTap: () {
              setState(() {
                Navigator.pop(context);
              });
            },
            child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100)),
                child: Center(child: Icon(Icons.arrow_back))),
          )),
      Positioned(
          left: 75,
          top: 30,
          child: Text("Delete User Data",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold))),
      Center(
        child: InkWell(
          onTap: () {
            databaseServices.deleteFields(userid);
            Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Home()));
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: 250,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(10)),
            child: Center(
                child: Text("Delete user data from Firebase",
                    style: TextStyle(color: Colors.white))),
          ),
        ),
      )
    ]));
  }
}
