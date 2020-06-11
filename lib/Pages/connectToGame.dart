import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:partykviz/Services/GameManager.dart' as GameManager;

import 'lobby.dart';

class ConnectToGame extends StatefulWidget {
  @override
  _ConnectToGameState createState() => _ConnectToGameState();
}

class _ConnectToGameState extends State<ConnectToGame> {
  final myController = TextEditingController();
  String errorMessage = "";

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Připojit se ke hře"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
          ),
          Text("Zadej kód místnosti, ke které se chceš připojit."),
          Text("Je důležité dodržet velká a malá písmena."),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: TextFormField(
              controller: myController,
              maxLength: 5,
              decoration: InputDecoration(
                  hintText: 'Zadej kód místnosti',
                  filled: true,
                  fillColor: Colors.grey[100],
                  suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      color: Colors.green,
                      onPressed: () async {
                        String textValue = myController.value.text;

                        final playerDoc = Firestore.instance
                            .collection('Gamerooms')
                            .document(textValue);
                        final snapShot = await playerDoc.get();

                        if (snapShot == null || !snapShot.exists) {
                          setState(() {
                            errorMessage = "Neplatná místnost";
                          });
                        } else {
                          print("Should connect");
                          await GameManager.connectToGameroom(textValue);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      GameLobby()));
                        }
                      })),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            errorMessage,
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }
}
