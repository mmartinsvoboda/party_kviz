import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:partykviz/Services//GameManager.dart' as GameManager;

String roomName = "";
int questionNum = 0;
int topicNum = 0;
String admin = "";
String question = "";
String answer = "";
String topic = "";
Timestamp time = Timestamp.now();
bool started = false;
List<String> players = [];
List<String> selectedTopics = [];
List<String> selectedQuestions = [];

Future initGameroomsettings(String room, String playerName) async {
  roomName = room;
  questionNum = 0;
  topicNum = 0;
  admin = playerName;
  question = "";
  answer = "";
  topic = "";
  time = Timestamp.now();
  started = false;
  players = [playerName];
  selectedTopics = [];
  selectedQuestions = [];
}

Future createFirestoreGameRoom(String _playerName) async {
  await Firestore.instance.document("Gamerooms/$roomName").setData({
    "questionNum": questionNum,
    "topicNum": topicNum,
    "admin": admin,
    "question": question,
    "answer": answer,
    "topic": topic,
    "timestamp": time,
    "started": started,
    "players": players,
    "selectedTopics": selectedTopics,
    "selectedQuestions": selectedQuestions,
  }).then((value) async {
    await GameManager.startStream();
  });
}

Future connectFirestoreGameRoom(String playerName) async {
  await Firestore.instance.document("Gamerooms/$roomName").updateData({
    "players": FieldValue.arrayUnion([playerName])
  });

  await GameManager.startStream();
}

Future updateRoomInfo(DocumentSnapshot document) async {
  questionNum = document.data["questionNum"];
  topicNum = document.data["topicNum"];
  admin = document.data["admin"];
  question = document.data["question"];
  answer = document.data["answer"];
  if (topic != document.data["topic"]) {
    GameManager.updateCurrentTopic(document.data["topic"]);
  }
  topic = document.data["topic"];
  time = document.data["timestamp"];
  started = document.data["started"];
  players = List.from(document.data["players"]);
  selectedTopics = List.from(document.data["selectedTopics"]);
  selectedQuestions = List.from(document.data["selectedQuestions"]);
}

Future startGame() async {
  await Firestore.instance
      .document("Gamerooms/$roomName")
      .updateData({"started": true});
}

Future setQuestionNum(int num) async {
  await Firestore.instance
      .document("Gamerooms/$roomName")
      .updateData({"questionNum": num});
}

Future setTopicNum(int num) async {
  await Firestore.instance
      .document("Gamerooms/$roomName")
      .updateData({"topicNum": num});
}

Future setQuestion(String text) async {
  await Firestore.instance
      .document("Gamerooms/$roomName")
      .updateData({"question": text});
}

Future setAnswer(String text) async {
  await Firestore.instance
      .document("Gamerooms/$roomName")
      .updateData({"answer": text});
}

Future setTopic(String text) async {
  await Firestore.instance
      .document("Gamerooms/$roomName")
      .updateData({"topic": text});
}

Future setTime() async {
  await Firestore.instance
      .document("Gamerooms/$roomName")
      .updateData({"timestamp": Timestamp.now()});
}

Future addSelectedTopics(String topic) async {
  await Firestore.instance.document("Gamerooms/$roomName").updateData({
    "selectedTopics": FieldValue.arrayUnion([topic])
  });
}

Future addSelectedQuestions(String question) async {
  await Firestore.instance.document("Gamerooms/$roomName").updateData({
    "selectedQuestions": FieldValue.arrayUnion([question])
  });
}

Future nullSelectedQuestions() async {
  await Firestore.instance
      .document("Gamerooms/$roomName")
      .updateData({"selectedQuestions": []});
}
