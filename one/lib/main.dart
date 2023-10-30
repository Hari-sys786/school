import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'Contacts page/AddContact.dart';
import 'Dashboard page/DashBoard.dart';
import 'dart:convert';
import 'dart:core';
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
  var classesName = Dash.a;
  static var classs = [
    'Nursery',
    'Lkg',
    'Ukg',
    'First',
    'Second',
    'Third',
    'Fourth',
    'Fifth',
    'Sixth',
    'Seventh',
    'Eight',
  ];

  @override
  void initState() {
    super.initState();
    dateCheck();
    balanceCheck();
  }

  Future<void> dateCheck() async {
    DatabaseReference del = FirebaseDatabase.instance.ref();
    late Query ref = del.child('Staff');
    DatabaseEvent event = await ref.once();
    DataSnapshot snapshot = event.snapshot;
    Map<dynamic, dynamic> values =
        await snapshot.value as Map<dynamic, dynamic>;
    var count = 0;
    DateTime now = DateTime.now();
    int datee = now.day;
    int monn = now.month;
    if (monn == 7 && datee == 06) {
      count = count + 1;
      if (count == 1) {
        try {
          var res = await http.get(Uri.parse(
              "https://kenndy-a2554-default-rtdb.asia-southeast1.firebasedatabase.app/Staff.json?"));
          Map<dynamic, dynamic> extractedData =
              json.decode(res.body) as Map<dynamic, dynamic>;
          extractedData.forEach((name, staff) async {
            for (var i = 0; i < classesName.length; i++) {
              if (staff['value'] != "Staff") {
                if (classs.contains(staff['value'])) {
                  var index = classs.indexOf(staff['value']);
                  // values.forEach((key, value) async {
                  //   if (value['value'] == "Eight") {
                  //     await del.child('Staff').child(key).remove();
                  //   } else {
                  //     print(key);
                  //     await del.child(key).update({
                  //       'name': value['name'],
                  //       'number': value['number'],
                  //       'type': value['type'],
                  //       'value': classs[index + 1]
                  //     });
                  //   }
                  // });
                  for (final entry in values.entries) {
                    final key = entry.key;
                    final value = entry.value;

                    if (value['value'] == "Eight") {
                      await del.child('Staff').child(key).remove().whenComplete(() => Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      pageBuilder: (BuildContext context, Animation<double> animation,
                                              Animation<double> secAnimation) =>
                                          DashBoard())));
                    } else {
                      print(key);
                      await del.child(key).update({
                        'name': value['name'],
                        'number': value['number'],
                        'type': value['type'],
                        'value': classs[index + 1]
                      }).whenComplete(() => Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      pageBuilder: (BuildContext context, Animation<double> animation,
                                              Animation<double> secAnimation) =>
                                          DashBoard())));
                    }
                  }
                }
              }
            }
          });
        } on Exception catch (e) {
          print("hahah ${e}");
        }
      }
    } else {
      print("exceed");
      count = 0;
    }
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
