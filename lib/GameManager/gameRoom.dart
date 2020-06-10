import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:partykviz/GameManager/gameManager.dart' as GameManager;

class GameRoom {
  String roomName;
  List<DocumentReference> allTopics = [];
  List<DocumentReference> selectedTopics = [];

  String topic = "";
  String question = "";
  int topicNum = 0;
  int questionNum = 0;

  Stream<DocumentSnapshot> stream;
  StreamSubscription streamSubscription;
  DocumentSnapshot snapshot;

  GameRoom({this.roomName});

  Future createFirestoreGameRoom(String adminName) async {
    await Firestore.instance.document("Gamerooms/$roomName").setData({
      "gamekey": roomName,
      "numQuestion": 0,
      "numTopic": 0,
      "Admin": adminName,
      "SecondAdmin": "",
      "Question": "",
      "Topic": "",
      "timestamp": DateTime.now().toUtc().millisecondsSinceEpoch,
      "hasStarted": false,
      "players": [adminName],
    });

    stream = Firestore.instance
        .collection("Gamerooms")
        .document(roomName)
        .snapshots();
    streamSubscription = Firestore.instance
        .collection("Gamerooms")
        .document(roomName)
        .snapshots()
        .listen((event) {
      snapshot = event;
    });

    if (allTopics.length == 0) {
      DocumentSnapshot snapshot;
      var document = Firestore.instance.document("Topics/Topic Manager");
      document.get().then((value) {
        snapshot = value;
        allTopics = List.from(snapshot.data["topics"]);
        print("Topics loaded");
      });
    }
  }

  Future connectFirestoreGameRoom(String playerName) async {
    await Firestore.instance.document("Gamerooms/$roomName").updateData({
      "players": FieldValue.arrayUnion([playerName])
    });

    stream = Firestore.instance
        .collection("Gamerooms")
        .document(roomName)
        .snapshots();
    streamSubscription = Firestore.instance
        .collection("Gamerooms")
        .document(roomName)
        .snapshots()
        .listen((event) {
      snapshot = event;
    });

    if (allTopics.length == 0) {
      DocumentSnapshot snapshot;
      var document = Firestore.instance.document("Topics/Topic Manager");
      document.get().then((value) {
        snapshot = value;
        allTopics = List.from(snapshot.data["topics"]);
        print("Topics loaded");
      });
    }
  }
}
