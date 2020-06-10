import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:partykviz/GameManager/player.dart';
import 'package:partykviz/GameManager/gameRoom.dart';

import 'package:random_string/random_string.dart';

Player player;
GameRoom gameRoom;

int numQuestion = gameRoom.snapshot.data["numQuestion"];
int numTopic = gameRoom.snapshot.data["numTopic"];

Future createPlayer(String name) async {
  player = Player(name: name);
  await player.createFirestorePlayer();
}

Future makeGameroom(String roomName) async {
  gameRoom = GameRoom(roomName: roomName);
  await gameRoom.createFirestoreGameRoom(player.name);
  print("Room $roomName made");
  await player.setAdmin();
}

Future connectToGameroom(String roomName) async {
  gameRoom = GameRoom(roomName: roomName);
  await player.looseAdmin();
  await gameRoom.connectFirestoreGameRoom(player.name);
}

Future nextGame() {
  numQuestion = gameRoom.snapshot.data["numQuestion"];
  numTopic = gameRoom.snapshot.data["numTopic"];
  if (numTopic == 0 || numQuestion == 5) {
    if (numTopic == 5) {
      print("End of GAME");
    } else {
      getNextTopic();
    }
  } else if (numQuestion < 5) {
    getNextQuestion(gameRoom.snapshot.data["Topic"]);
  }
}

Future<int> getNextQuestion(DocumentReference topic) async {
  DocumentSnapshot snapshot;
  topic.get().then((value) {
    snapshot = value;
    List list = List.from(snapshot.data["Questions"]);
    numQuestion++;
    int i = randomBetween(0, list.length);
    while (false) {
      i = randomBetween(0, gameRoom.allTopics.length);
      if (gameRoom.selectedTopics.length == gameRoom.allTopics.length) {
        print("end of array");
        i = -1;
        break;
      }
    }
    Firestore.instance
        .collection("Gamerooms")
        .document(gameRoom.roomName)
        .updateData(
            {"Question": list[i]["Question"], "numQuestion": numQuestion});

    gameRoom.question = list[i]["Question"];
    gameRoom.questionNum++;
  });
}

Future getNextTopic() async {
  print("Get Next Topic");
  int i = randomBetween(0, gameRoom.allTopics.length);
  while (gameRoom.selectedTopics.contains(gameRoom.allTopics[i])) {
    i = randomBetween(0, gameRoom.allTopics.length);
    if (gameRoom.selectedTopics.length == gameRoom.allTopics.length) {
      print("end of array");
      i = -1;
      break;
    }
  }
  if (i != -1) {
    gameRoom.selectedTopics.add(gameRoom.allTopics[i]);
    numTopic++;
    numQuestion = 0;
    await getNextQuestion(gameRoom.allTopics[i]);
    Firestore.instance
        .collection("Gamerooms")
        .document(gameRoom.roomName)
        .updateData({
      "Topic": gameRoom.allTopics[i],
      "numTopic": numTopic,
      "numQuestion": numQuestion
    });
    //Get topic name
    gameRoom.allTopics[i].get().then((value) {
      gameRoom.topic = value.documentID;
      gameRoom.topicNum++;
    });
  } else {
    print("Out of bounds - Game Over");
  }
}
