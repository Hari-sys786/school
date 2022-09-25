import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Dashboard page/DashBoard.dart';

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
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(milliseconds: 1000),
        () => Navigator.push(
            context,
            PageRouteBuilder(
                transitionDuration: Duration(
                  milliseconds: 300,
                ),
                transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secAnimation,
                    Widget child) {
                  return ScaleTransition(scale: animation, child: child);
                },
                pageBuilder: (BuildContext context, Animation<double> animation,
                        Animation<double> secAnimation) =>
                    DashBoard())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
