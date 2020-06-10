import 'package:flutter/material.dart';
import 'package:partykviz/Pages/lobby.dart';
import 'package:random_string/random_string.dart';
import 'connectToGame.dart';

import 'package:partykviz/GameManager/gameManager.dart' as GameManager;

class MainMenu extends StatefulWidget {
  MainMenu({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              RaisedButton(
                child: Text("Nová hra"),
                onPressed: () async {
                  String roomName = randomAlphaNumeric(5);
                  await GameManager.makeGameroom(roomName);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => GameLobby()));
                },
              ),
              RaisedButton(
                child: Text("Připojit se ke hře"),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => ConnectToGame()));
                },
              )
            ],
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }
}
