import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:partykviz/Pages/connectToGame.dart';
import 'package:random_string/random_string.dart';

import 'package:partykviz/Services/GameManager.dart' as GameManager;

import 'Lobby.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool hasName = false;
  final nicknameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Vítá tě Párty kvíz!"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Párty kvíz je vědomostní mobilní hra, díky které si můžeš s přáteli pořádně zasoutěžit.",
              style: TextStyle(fontSize: 20, color: Colors.black87),
            ),
            SizedBox(
              height: 50,
            ),
            hasName ? startGame() : getNickname(),
          ],
        ),
      ),
    );
  }

  Widget startGame() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
          ),
          RaisedButton(
            child: Text("Nová hra"),
            onPressed: () async {
              await GameManager.makeGameroom(randomAlphaNumeric(5));
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
    );
  }

  Widget getNickname() {
    return Column(
      children: [
        Text("Vyber si přezdívku"),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          maxLength: 15,
          controller: nicknameController,
          autofocus: true,
          textAlign: TextAlign.left,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter(RegExp("[a-z A-Z á-ú Á-Ú 0-9]"))
          ],
          decoration: InputDecoration(
            hintText: "Přezdívka",
            filled: true,
            fillColor: Colors.grey[100],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Center(
          child: RaisedButton(
            color: Colors.green,
            textColor: Colors.white,
            child: Text("Jde se na to!"),
            onPressed: () async {
              String textValue = nicknameController.value.text.trim();
              if (textValue != "") {
                await GameManager.createPlayer(textValue);
                setState(() {
                  hasName = true;
                });
                //await createPlayer(textValue);
              }
            },
          ),
        ),
      ],
    );
  }
}
