import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:partykviz/GameManager/gameManager.dart' as GameManager;

class QuestionView extends StatefulWidget {
  @override
  _QuestionViewState createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
  int counter;
  Timer everySecond;
  Timer roundTime;
  Timer tenSecs;
  Timer tenSecsSecs;

  @override
  void initState() {
    super.initState();
    GameManager.nextGame();

    counter = 45;

    // defines a timer
    everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        counter--;
      });
      if (counter <= 0) {
        everySecond.cancel();
        counter = 0;
      }
      ;
    });
    roundTime = Timer.periodic(Duration(seconds: 46), (Timer t) {
      setState(() {
        print("46 seconds gone, round finished");
      });
      roundTime.cancel();

      tenSecs = Timer.periodic(Duration(seconds: 10), (Timer t) {
        //After 10 seconds go to the next page
        print("10 secs gone, going to the next Page");
        tenSecs.cancel();
        tenSecsSecs.cancel();
      });

      tenSecsSecs = Timer.periodic(Duration(seconds: 1), (Timer t) {
        //Each second check if all players answered
        print("Checking if all players answered");
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    roundTime.cancel();
    everySecond.cancel();
    tenSecsSecs.cancel();
    tenSecs.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(GameManager.gameRoom.roomName),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
              width: double.infinity,
            ),
            RaisedButton(
              child: Text("Další otázka"),
              onPressed: () {
                GameManager.nextGame();
              },
            ),
            Text(
                "${GameManager.gameRoom.topicNum} ${GameManager.gameRoom.topic}"),
            Text(
                "${GameManager.gameRoom.questionNum} ${GameManager.gameRoom.question}"),
            Text(counter.toString()),
          ],
        ));
  }
}
