import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'login.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Log Out', icon: Icons.exit_to_app),
];

class _MyHomePageState extends State<MyHomePage> {
  Choice _selectedChoice = choices[0];

  File _image;

  @override
  void initState() {
    super.initState();
    getImageFromCamera();
  }

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  Future<void> _select(Choice choice) async {
    setState(() {
      _selectedChoice = choice;
    });
    switch (_selectedChoice.title) {
      case 'Log Out':
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('_isLoggedIn', false);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => AuthPage()));
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              PopupMenuButton<Choice>(
                onSelected: _select,
                itemBuilder: (BuildContext context) {
                  return choices.map((Choice choice) {
                    return PopupMenuItem<Choice>(
                      value: choice,
                      child: Text(choice.title),
                    );
                  }).toList();
                },
              ),
            ],
            title: Text('OCR-DEMO'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(blurRadius: 30, color: Colors.grey)
                  ]),
                  padding: EdgeInsets.only(top: 10),
                  child: Center(
                    child: _image == null
                        ? Text('No image selected.')
                        : Image.file(_image),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: FloatingActionButton(
                        elevation: 60,
                        heroTag: "btn1",
                        onPressed: getImageFromGallery,
                        child: Icon(Icons.add_a_photo),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: FloatingActionButton(
                        elevation: 60,
                        heroTag: "btn3",
                        onPressed: getImageFromCamera,
                        child: Icon(Icons.camera),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: FloatingActionButton(
                        elevation: 60,
                        heroTag: "btn2",
                        onPressed: sendData,
                        child: Icon(Icons.send),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendData() async {
    String resonsed;
    String base64Image;
    if (_image != null) {
      base64Image = base64Encode(_image.readAsBytesSync());
    } else {
      Toast.show("No Image Selected", context);
      Map map = {
        'image': base64Image,
      };
      var body = json.encode(map);
      String url = "http://192.168.1.35";
      try {
        http
            .post(url,
                headers: {"Content-Type": "application/json"}, body: body)
            .then((http.Response response) {
          final int statusCode = response.statusCode;
          if (statusCode < 200 || statusCode > 400 || json == null) {
            throw new Exception("Error while Fetching data");
          }
          resonsed = json.decode(response.body);
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  elevation: 40,
                  backgroundColor: Colors.teal[200],
                  title: Text("Text"),
                  content: SingleChildScrollView(child: Text(resonsed)),
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ],
                );
              });
        });
      } catch (e) {
        print("Error:$e");
      }
    }
  }

  DateTime currentBackPressTime;

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Toast.show("Please Press again to exit", context,
          duration: Toast.LENGTH_LONG);

      return Future.value(false);
    }
    return Future.value(true);
  }
}
