import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:partykviz/GameManager/gameManager.dart' as GameManager;
import 'package:partykviz/Pages/questionView.dart';

class GameLobby extends StatefulWidget {
  @override
  _GameLobbyState createState() => _GameLobbyState();
}

class _GameLobbyState extends State<GameLobby> {
  String now;
  dynamic everySecond;

  @override
  void initState() {
    super.initState();

    // sets first value
    now = DateTime.now().second.toString();

    // defines a timer
    everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
      startGame();
      setState(() {
        now = DateTime.now().second.toString();
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    everySecond.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nová hra"),
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
                      GameManager.gameRoom.roomName,
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
                  stream: GameManager.gameRoom.stream,
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
            GameManager.player.isAdmin
                ? Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      RaisedButton(
                        color: Colors.green,
                        child: Text("Spustit hru"),
                        onPressed: () {
                          setState(() {
                            Firestore.instance
                                .collection("Gamerooms")
                                .document(GameManager.gameRoom.roomName)
                                .updateData({"hasStarted": true});
                          });
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
      if (GameManager.gameRoom.snapshot.data["hasStarted"]) {
        print("Start Game");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => QuestionView()),
            (route) => false);
      } else {
        print("has not started yet.");
      }
    } catch (e) {}
  }
}
