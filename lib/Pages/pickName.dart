import 'package:flutter/material.dart';
import 'package:partykviz/GameManager/gameManager.dart' as GameManager;
import 'package:partykviz/Pages/mainMenu.dart';

class PickName extends StatefulWidget {
  PickName({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PickNameState createState() => _PickNameState();
}

class _PickNameState extends State<PickName> {
  bool hasName = false;
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Zvol si jméno:"),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: myController,
                  decoration: InputDecoration(
                      hintText: 'Zvol si jméno',
                      filled: true,
                      fillColor: Colors.grey[100],
                      suffixIcon: IconButton(
                          icon: Icon(Icons.send),
                          autofocus: true,
                          color: Colors.green,
                          onPressed: () async {
                            String textValue = myController.value.text;
                            if (textValue != "") {
                              await createPlayer(textValue);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MainMenu(
                                              title: 'Vítá tě Párty kvíz!')));
                            } else {
                              print("Error");
                            }
                          })),
                ),
              ],
            ),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }
}

Future createPlayer(String name) async {
  await GameManager.createPlayer(name);
}
