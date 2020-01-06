import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:camera/registration.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthpageState();
  }
}

class _AuthpageState extends State<AuthPage> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  bool _acceptTerms = false;

  String email, passwd;
  final emailController = TextEditingController();
  final pwdController = TextEditingController();

  String success;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5), BlendMode.dstATop)),
          ),
          padding: EdgeInsets.all(25),
          child: Center(
            child: SingleChildScrollView(
              child: new Form(
                child: formUI(),
                key: _key,
                autovalidate: _validate,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget formUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 140,
          width: 140,
          child: Image.asset("assets/images/logo.png"),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 50),
          child: Text(
            'OCR-Demo',
            style: TextStyle(fontSize: 35, color: Colors.white),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: TextFormField(
            validator: _validateEmail,
            style: new TextStyle(color: Colors.white),
            controller: emailController,
            textInputAction: TextInputAction.none,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                hasFloatingPlaceholder: true,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                // hintText: 'Enter your product title',
                labelStyle: TextStyle(color: Colors.white),
                labelText: 'Email Address'),
            onSaved: (String val) {
              email = val;
            },
          ),
        ),
        SizedBox(
          height: 25,
        ),
        TextFormField(
          validator: _validatePasswd,
          keyboardType: TextInputType.visiblePassword,
          style: new TextStyle(color: Colors.white),
          obscureText: true,
          decoration: InputDecoration(
              hasFloatingPlaceholder: true,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              // hintText: 'Enter your product description',
              labelStyle: TextStyle(color: Colors.white),
              labelText: 'Password'),
          onSaved: (String val) {
            passwd = val;
          },
          onChanged: (String value) {
            setState(() {});
          },
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(top: 25, right: 5),
            child: Text(
              'Forgot Password ?',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),

        // SwitchListTile(
        //   title: Text('I accept the Terms & Conditions',style: TextStyle(color: Colors.white),),
        //   value: _acceptTerms,
        //   onChanged: (bool value) {
        //     setState(() {
        //       _acceptTerms = value;
        //     });
        //   },
        // ),
        SizedBox(
          height: 25,
        ),
        FlatButton(
          shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              side: BorderSide(color: Colors.white)),
          padding: EdgeInsets.only(left: 50, right: 50),
          // color: Theme.of(context).buttonColor,
          textColor: Colors.white,
          child: Text('Login'),
          onPressed: () {
            //_sendToServer();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext cotext) => MyHomePage(),
              ),
            );
          },
        ),
        SizedBox(
          height: 30,
        ),
        FlatButton(
          shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              side: BorderSide(color: Colors.white)),
          padding: EdgeInsets.only(left: 50, right: 50),
          // color: Theme.of(context).buttonColor,
          textColor: Colors.white,
          child: Text('Sign Up'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext cotext) => RegistrationPage(),
              ),
            );
          },
        )
      ],
    );
  }

  String _validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  String _validatePasswd(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Password is Required";
      // } else if (!regExp.hasMatch(value)) {
      //   return "Invalid Password";
    } else {
      return null;
    }
  }

  _sendToServer() {
    if (_key.currentState.validate()) {
      // No any error in validation
      _key.currentState.save();
      _datareciver(email, passwd);
    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
  }

  _datareciver(String email, String pwd) async {
    var data;
    var uri = Uri.parse(
        "http://hardcastle.co.in/PHP_WEB/prabhiyw_glitedge_beta/api/login_manager.php");
    var request = new http.MultipartRequest("POST", uri);
    request.fields['email'] = email;
    request.fields['pwd'] = pwd;
    var response = await request.send().timeout(const Duration(minutes: 2));
    if (response.statusCode == 200) print('Uploaded!');
    response.stream.transform(utf8.decoder).listen((value) async {
      data = jsonDecode(value);
      print(data);
      if (data["DATA"] == "SUCCESS") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext cotext) => MyHomePage(),
          ),
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
//TODO Data manager Api is Changed;

        prefs.setBool('_isLoggedIn', true);
        prefs.setString('userName', data["USER_NAME"]);
        prefs.setString('userID', data["USER_ID"]);

        // }
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.red[100],
                title: Text("Invalid Credentials"),
                content: Text(
                    "Please enter valid credentials and If you don't have then please register"),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ],
              );
            });
      }
    });
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
