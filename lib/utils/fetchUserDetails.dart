import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget fetchUserData() {
  return StreamBuilder(
    stream: FirebaseFirestore.instance.collection("users").snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Center(
          child: Text("Something is wrong"),
        );
      }

      return Container(
          padding: EdgeInsets.only(top: 100),
          child: ListView.builder(
              itemCount: snapshot.data == null ? 0 : snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot _documentSnapshot = snapshot.data!.docs[index];
                return Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.purple),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _documentSnapshot.data().toString().contains('MobileNo')
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                    Text("MobileNo: "),
                                    Text(_documentSnapshot['MobileNo'] ?? "",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  ])
                            : Container(),
                        _documentSnapshot.data().toString().contains('Address')
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                    Text("Address"),
                                    Text(
                                        _documentSnapshot
                                                .data()
                                                .toString()
                                                .contains('Address')
                                            ? _documentSnapshot['Address']
                                            : "",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  ])
                            : Container(),
                        _documentSnapshot.data().toString().contains('Age')
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                    Text("Age"),
                                    Text(
                                        _documentSnapshot
                                                .data()
                                                .toString()
                                                .contains('Age')
                                            ? _documentSnapshot['Age']
                                            : "",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                  ])
                            : Container()
                      ],
                    ),
                  ),
                );
              }));
    },
  );
}
