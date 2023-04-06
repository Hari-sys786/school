import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Contacts page/AddContact.dart';
import 'Dashboard page/DashBoard.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  static var balance = 0;

  @override
  void initState() {
    super.initState();
    balanceCheck();
  }

  balanceCheck() async {
    try {
      http.Response response = await http
          .get(Uri.parse("https://smssending1.000webhostapp.com/balance.php"))
          .timeout(Duration(seconds: 20));
      var res = json.decode(response.body);
      setState(() {
        balance = res["balance"]["sms"];
      });
    } on TimeoutException {
      var msgs = "Timeout Error";
      showToast(msgs);
    } on SocketException {
      var msgs = "Turn on internet connection";
      showToast(msgs);
    } on FormatException {
      var msgs = "Something went wrong";
      showToast(msgs);
    }
    Timer(
        Duration(milliseconds: 1000),
        () => Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (BuildContext context, Animation<double> animation,
                        Animation<double> secAnimation) =>
                    DashBoard())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'images/Logo.png',
                height: 190.0,
              ),
            ),
            SizedBox(height: 30.0),
          ]),
    );
  }
}
