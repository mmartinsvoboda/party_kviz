import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  String name = "";
  String answer = "";
  bool isAdmin = false;
  int correct = 0;
  int wrong = 0;
  int points = 0;
  String path = "";

  Player({this.name});

  Future createFirestorePlayer() async {
    final playerDoc = Firestore.instance.collection('Players').document(name);
    final snapShot = await playerDoc.get();

    if (snapShot == null || !snapShot.exists) {
      // Document with id == docId doesn't exist.
      print("Document doesn't exist, creating Player");
      playerDoc.setData({
        "Nickname": name,
        "path": "Players/$name",
        "isAdmin": false,
        "answer": "",
        "correct": 0,
        "wrong": 0,
        "points": 0
      });
    } else {
      print("Document exists!");
      playerDoc.setData({
        "Nickname": name,
        "path": "Players/$name",
        "isAdmin": false,
        "answer": "",
        "correct": 0,
        "wrong": 0,
        "points": 0
      });
    }

    path = "Players/$name";
  }

  Future setAdmin() {
    final playerDoc = Firestore.instance.collection('Players').document(name);
    playerDoc.updateData({"isAdmin": true});
    isAdmin = true;
  }

  Future looseAdmin() {
    final playerDoc = Firestore.instance.collection('Players').document(name);
    playerDoc.updateData({"isAdmin": false});
    isAdmin = false;
  }
}
