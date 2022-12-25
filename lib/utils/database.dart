import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  updateTask(Map<String, dynamic> taskMap, String documentId) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(documentId)
        .set(taskMap, SetOptions(merge: true));
  }

  dynamic createTask(Map<String, dynamic> taskMap) {
    FirebaseFirestore.instance.collection("users").add(taskMap);
  }

  getTasks() async {
    return await FirebaseFirestore.instance.collection("users").snapshots();
  }

  deleteTask(String documentId) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(documentId)
        .delete()
        .catchError((e) {
      print(e.toString());
    });
  }

  deleteFields(String documentId) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(documentId)
        .update({'MobileNo': FieldValue.delete(),'Address':FieldValue.delete(),'Age':FieldValue.delete()}).catchError((e) {
      print(e.toString());
    });
  }
}
