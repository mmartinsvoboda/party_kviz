import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:partykviz/Services/Room.dart' as GameRoom;
import 'package:partykviz/Services/Player.dart' as Player;

class QuestionView extends StatefulWidget {
  @override
  _QuestionViewState createState() => _QuestionViewState();
}

class _QuestionViewState extends State<QuestionView> {
  int counter;
  bool bellowStartTime = false;

  int roundTime = 50;
  int startTime = 45;

  int sendAnswerTime = 5;
  bool answered = false;

  Timer everySecond;
  Timer waitForAnswers;

  final answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    DateTime finalTime =
        GameRoom.time.toDate().toUtc().add(Duration(seconds: roundTime));

    counter = finalTime.difference(Timestamp.now().toDate()).inSeconds;

    everySecond = Timer.periodic(Duration(milliseconds: 500), (Timer t) async {
      setState(() {
        if (counter > 0) {
          counter = finalTime.difference(Timestamp.now().toDate()).inSeconds;
        }
      });
      if (counter <= startTime && !bellowStartTime) {
        bellowStartTime = true;
      }
      if (counter <= 0) {
        print(sendAnswerTime);
        sendAnswerTime--;
        if (!answered) {
          await Player.setAnswer(answerController.value.text);
          answered = true;
        }
        if (sendAnswerTime < 0) {
          print("Answered");
          everySecond.cancel();
          //todo restart sendAnserTime if not all players answered
          //todo GotoVotePage
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Téma ${GameRoom.topicNum}/5 :${GameRoom.topic}"),
              Text(
                "Otázka: ${GameRoom.questionNum}/5",
                style: TextStyle(fontSize: 16),
              )
            ],
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Text(counter.toString()),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
              width: double.infinity,
            ),
            bellowStartTime ? questionBox() : SizedBox(),
            SizedBox(
              height: 20,
            ),
            //Text(counter.toString()),
          ],
        ));
  }

  Widget questionBox() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${GameRoom.question}",
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: answerController,
              autofocus: true,
              textAlign: TextAlign.left,
              minLines: 1,
              maxLines: 20,
              decoration: InputDecoration(
                hintText:
                    "Odpověď bude odeslána automaticky po doběhnutí času!",
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ]),
    );
  }
}
