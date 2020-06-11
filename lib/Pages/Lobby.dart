import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:partykviz/Pages/Quesion.dart';
import 'package:partykviz/Services/GameManager.dart' as GameManager;
import 'package:partykviz/Services/Player.dart' as Player;
import 'package:partykviz/Services/Room.dart' as GameRoom;

class GameLobby extends StatefulWidget {
  @override
  _GameLobbyState createState() => _GameLobbyState();
}

class _GameLobbyState extends State<GameLobby> {
  Timer everySecond;

  @override
  void initState() {
    super.initState();
    if (GameManager.allTopics.length == 0 && GameRoom.admin == Player.name) {
      var document = Firestore.instance.document("Topics/Topic Manager");
      document.get().then((value) {
        GameManager.allTopics.addAll(List.from(value.data["topics"]));
        print("${GameManager.allTopics.length} topics loaded");
      });
    }

    GameManager.startStream();
    everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
      startGame();
      //setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    everySecond.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nová hra"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Kód místnosti"),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                color: Colors.green,
                width: 250,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  child: Center(
                    child: Text(
                      GameRoom.roomName,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "Hráči",
              style: TextStyle(fontSize: 40),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: StreamBuilder(
                  stream: GameManager.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text("Loading...");
                    }

                    List<String> players = List.from(snapshot.data["players"]);
                    int playerCount = players.length;
                    return ListView.builder(
                        itemCount: playerCount,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.green)),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              child: Text(
                                players[index],
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            )),
                          );
                        });
                  }),
            ),
            (GameRoom.admin == Player.name)
                ? Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      RaisedButton(
                        color: Colors.green,
                        child: Text("Spustit hru"),
                        onPressed: () async {
                          await GameManager.nextRound();
                          await GameRoom.startGame();
                        },
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  void startGame() async {
    try {
      if (GameManager.snapshot.data["started"]) {
        print("Start Game");

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => QuestionView()),
            (route) => false);
      } else {
        print("Has not started yet.");
      }
    } catch (e) {}
  }
}
