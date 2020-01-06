import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OCR-DEMO'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(boxShadow: [BoxShadow(blurRadius: 30,color: Colors.grey)]),
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
    );
  }

  Future<void> sendData() async {
    String base64Image = base64Encode(_image.readAsBytesSync());
    Map map = {
      'image': base64Image,
    };
    var body = json.encode(map);
    String url = "http://3.222.221.21";
    http.post(url, headers: {"Content-Type": "application/json"}, body: body)
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while Fetching data");
      }
     String resonsed = json.decode(response.body);
     print(resonsed);
    });
  }
}
