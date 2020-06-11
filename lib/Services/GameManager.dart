import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:partykviz/Services/Player.dart' as Player;
import 'package:partykviz/Services/Room.dart' as GameRoom;
import 'package:random_string/random_string.dart';

List<String> allTopics = [];
DocumentSnapshot currentTopic;

Stream<DocumentSnapshot> stream;
StreamSubscription streamSubscription;
DocumentSnapshot snapshot;

Future startStream() async {
  stream = Firestore.instance
      .collection("Gamerooms")
      .document(GameRoom.roomName)
      .snapshots();
  streamSubscription = Firestore.instance
      .collection("Gamerooms")
      .document(GameRoom.roomName)
      .snapshots()
      .listen((event) async {
    snapshot = event;
    await GameRoom.updateRoomInfo(event);
  });
}

Future createPlayer(String name) async {
  Player.createPlayer(name);
  await Player.createFirestorePlayer();
}

Future makeGameroom(String roomName) async {
  GameRoom.initGameroomsettings(roomName, Player.name);
  await GameRoom.createFirestoreGameRoom(Player.name);
  print("Room $roomName made");
}

Future connectToGameroom(String roomName) async {
  GameRoom.initGameroomsettings(roomName, Player.name);
  await GameRoom.connectFirestoreGameRoom(Player.name);
}

Future updateCurrentTopic(String topic) async {
  currentTopic = await Firestore.instance.document("Topics/$topic").get();
}

Future nextRound() async {
  if (GameRoom.topicNum == 0 || GameRoom.questionNum == 5) {
    await getNextTopic();
    await getNextQuestion();
  } else {
    await getNextQuestion();
  }
}

Future getNextTopic() async {
  print("Get Next Topic");
  int i = randomBetween(0, allTopics.length);
  while (GameRoom.selectedTopics.contains(allTopics[i])) {
    i = randomBetween(0, allTopics.length);
    if (GameRoom.selectedTopics.length == allTopics.length) {
      print("End of array - No more topics");
      i = -1;
      break;
    }
  }
  if (i != -1) {
    String nextTopic = allTopics[i];
    await GameRoom.addSelectedTopics(nextTopic);
    await GameRoom.setQuestionNum(0);
    await GameRoom.setTopicNum(GameRoom.topicNum + 1);
    await GameRoom.setTopic(nextTopic);
    await GameRoom.nullSelectedQuestions();
    await updateCurrentTopic(nextTopic);
  } else {
    print("Out of bounds - Game Over");
  }
}

Future getNextQuestion() async {
  print("Get next question");
  //GameRoom.setTopicNum(0);
  List<Map> questions = List.from(currentTopic.data["Questions"]);
  int i = randomBetween(0, questions.length);
  while (GameRoom.selectedQuestions.contains(questions[i]["Question"])) {
    i = randomBetween(0, questions.length);
    if (GameRoom.selectedQuestions.length == questions.length) {
      print("End of array - No more questions");
      i = -1;
      break;
    }
  }
  if (i != -1) {
    await GameRoom.addSelectedQuestions(questions[i]["Question"]);
    await GameRoom.setQuestionNum(GameRoom.questionNum + 1);
    await GameRoom.setQuestion(questions[i]["Question"]);
    await GameRoom.setAnswer(questions[i]["Answer"]);
    await GameRoom.setTime();
  } else {
    print("Out of bounds - Game Over");
  }
}
