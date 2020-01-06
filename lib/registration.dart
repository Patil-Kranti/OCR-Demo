import 'package:camera/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  bool _acceptTerms = false;

  String firstName, lastName, phoneNumber, address, companyName, email, passwd;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          elevation: 10.0,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: false,
            background: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.blueGrey.shade800,
                Colors.black87,
              ])),
            ),
            title: Row(
              children: <Widget>[
                FlutterLogo(
                  colors: Colors.yellow,
                  textColor: Colors.black87,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text('OCR-Demo')
              ],
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.19), BlendMode.dstATop)),
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
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 10, right: 15),
                child: TextFormField(
                  validator: _validateFirstName,
                  style: new TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                      hasFloatingPlaceholder: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black87),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black87),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      labelStyle: TextStyle(color: Colors.black87),
                      labelText: 'First Name'),
                  onSaved: (String val) {
                    firstName = val;
                  },
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: TextFormField(
                  validator: _validateLastName,
                  style: new TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                      hasFloatingPlaceholder: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black87),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black87),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      labelStyle: TextStyle(color: Colors.black87),
                      labelText: 'Last Name'),
                  onSaved: (String val) {
                    lastName = val;
                  },
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: TextFormField(
            validator: _validateEmail,
            style: new TextStyle(color: Colors.black87),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                hasFloatingPlaceholder: true,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                labelStyle: TextStyle(color: Colors.black87),
                labelText: 'Email Address'),
            onSaved: (String val) {
              email = val;
            },
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: TextFormField(
            validator: _validatePasswd,
            style: new TextStyle(color: Colors.black87),
            decoration: InputDecoration(
                hasFloatingPlaceholder: true,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                labelStyle: TextStyle(color: Colors.black87),
                labelText: 'Password'),
            onSaved: (String val) {
              passwd = val;
            },
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: TextFormField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
            ],
            validator: _validatePhoneNumber,
            style: new TextStyle(color: Colors.black87),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                hasFloatingPlaceholder: true,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                labelStyle: TextStyle(color: Colors.black87),
                labelText: 'Phone Number'),
            onSaved: (String val) {
              phoneNumber = val;
            },
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: TextFormField(
            validator: _validateAddress,
            style: new TextStyle(color: Colors.black87),
            decoration: InputDecoration(
                hasFloatingPlaceholder: true,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                labelStyle: TextStyle(color: Colors.black87),
                labelText: 'Address'),
            onSaved: (String val) {
              address = val;
            },
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: TextFormField(
            validator: _validateCompanyName,
            style: new TextStyle(color: Colors.black87),
            decoration: InputDecoration(
                hasFloatingPlaceholder: true,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                labelStyle: TextStyle(color: Colors.black87),
                labelText: 'Company Name'),
            onSaved: (String val) {
              companyName = val;
            },
          ),
        ),
        SizedBox(
          height: 15,
        ),
        SwitchListTile(
          title: Text(
            'I accept the Terms & Conditions',
            style: TextStyle(color: Colors.black87),
          ),
          value: _acceptTerms,
          onChanged: (bool value) {
            setState(() {
              _acceptTerms = value;
            });
          },
        ),
        FlatButton(
          shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              side: BorderSide(color: Colors.black87)),
          padding: EdgeInsets.only(left: 50, right: 50),
          textColor: Colors.black87,
          child: Text('Sign Up'),
          onPressed: () {
            _sendToServer();
          },
        ),
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
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Password";
    } else {
      return null;
    }
  }

  String _validatePhoneNumber(String value) {
    String pattern =
        r'^(?:(?:\+?1\s*(?:[.-]\s*)?)?(?:\(\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\s*\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\s*(?:[.-]\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\s*(?:[.-]\s*)?([0-9]{4})(?:\s*(?:#|x\.?|ext\.?|extension)\s*(\d+))?$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Phone Number is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Phone Number";
    } else {
      return null;
    }
  }

  _sendToServer() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      if (_acceptTerms) {
        _datareciver(
          firstName,
          lastName,
          email,
          passwd,
          phoneNumber,
          address,
          companyName,
        );
      } else {
        Toast.show("Please Accept The Terms & Conditions", context,
            duration: Toast.LENGTH_LONG);
      }
    } else {
// validation error
      setState(() {
        _validate = true;
      });
    }
  }

  _datareciver(
    String firstName,
    String lastName,
    String email,
    String pwd,
    String phoneNumber,
    String address,
    String companyName,
  ) async {
    FirebaseUser user;
    try {
      user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: email.trim(), password: passwd.trim()))
          .user;
      print(user.uid);
      final databasereference = FirebaseDatabase.instance.reference();
      databasereference.child(user.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'address': address,
        'companyName': companyName,
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              elevation: 40,
              backgroundColor: Colors.teal[200],
              title: Text("Sucess"),
              content: Text("User Registered Sucessfully"),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => AuthPage()));
                    })
              ],
            );
          });
    } catch (e) {
      print('Error:$e');
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.red[100],
              title: Text("Error In Registration"),
              content: Text(e),
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

    if (user != null) {
    } else {}
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

  String _validateFirstName(String value) {
    if (value.length == 0) {
      return "First Name is Required";
    } else {
      return null;
    }
  }

  String _validateLastName(String value) {
    if (value.length == 0) {
      return "Last Name is Required";
    } else {
      return null;
    }
  }

  String _validateAddress(String value) {
    if (value.length == 0) {
      return "Address is Required";
    } else {
      return null;
    }
  }

  String _validateCompanyName(String value) {
    if (value.length == 0) {
      return "Company Name is Required";
    } else {
      return null;
    }
  }
}
