import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:partykviz/Services/Room.dart' as GameRoom;

String name;
String answer;
int votes;
int correct;
int wrong;
int points;

void createPlayer(String playerName) {
  name = playerName;
  answer = "";
  votes = 0;
  correct = 0;
  wrong = 0;
  points = 0;
}

Future createFirestorePlayer() async {
  final playerDoc = Firestore.instance.collection('Players').document(name);
  final snapShot = await playerDoc.get();

  //todo better solution when player already exists
  if (snapShot == null || !snapShot.exists) {
    // Document with id == docId doesn't exist.
    print("Document doesn't exist, creating Player");
    playerDoc.setData({
      "Nickname": name,
      "answer": "",
      "votes": 0,
      "correct": 0,
      "wrong": 0,
      "points": 0
    });
  } else {
    print("Document exists!");
    playerDoc.setData({
      "Nickname": name,
      "answer": "",
      "votes": 0,
      "correct": 0,
      "wrong": 0,
      "points": 0
    });
  }
}

Future checkIfCorrect() async {
  DocumentSnapshot player =
      await Firestore.instance.collection('Players').document(name).get();
  if (player.data["votes"] >= GameRoom.players.length / 2) {
    await addPoint();
  }
  await nullAnser();
  await nullVotes();
}

Future setAnswer(String text) async {
  Firestore.instance
      .collection('Players')
      .document(name)
      .updateData({"answer": text});
}

Future nullAnser() async {
  Firestore.instance
      .collection('Players')
      .document(name)
      .updateData({"answer": ""});
}

Future addPoint() async {
  final DocumentReference postRef =
      Firestore.instance.document('Players/$name');
  Firestore.instance.runTransaction((Transaction tx) async {
    DocumentSnapshot postSnapshot = await tx.get(postRef);
    if (postSnapshot.exists) {
      await tx.update(postRef,
          <String, dynamic>{'points': postSnapshot.data['points'] + 1});
    }
  });
}

Future nullPoints() async {
  Firestore.instance
      .collection('Players')
      .document(name)
      .updateData({"points": 0});
}

Future addVote(String name) async {
  final DocumentReference postRef =
      Firestore.instance.document('Players/$name');
  Firestore.instance.runTransaction((Transaction tx) async {
    DocumentSnapshot postSnapshot = await tx.get(postRef);
    if (postSnapshot.exists) {
      await tx.update(
          postRef, <String, dynamic>{'votes': postSnapshot.data['votes'] + 1});
    }
  });
}

Future removeVote(String name) async {
  final DocumentReference postRef =
      Firestore.instance.document('Players/$name');
  Firestore.instance.runTransaction((Transaction tx) async {
    DocumentSnapshot postSnapshot = await tx.get(postRef);
    if (postSnapshot.exists) {
      await tx.update(
          postRef, <String, dynamic>{'votes': postSnapshot.data['votes'] - 1});
    }
  });
}

Future nullVotes() async {
  Firestore.instance
      .collection('Players')
      .document(name)
      .updateData({"votes": 0});
}
