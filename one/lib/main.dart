import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
      color: Colors.black,
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
  static var siteUrl;
  var url;
  var msgs;
  var isLoading = true;
  var balCheck = false;
  var errorCheck = false;
  var errorCheck_bal = false;
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
    // Delay for 5 seconds before making the API call
    Future.delayed(Duration(seconds: 3), () {
      // Perform your API call here
      site();
      // You can replace this with your actual API call logic
      // For now, we simulate a simple API call with a delay of 2 seconds
      Future.delayed(Duration(seconds: 2), () {
        // API call completed, update the widget state
        setState(() {
          isLoading = false; // Set loading indicator to false
        });
      });
    });
  }

  handleApierror(e) {
    print(e);
    errorCheck_bal = true;
     if (e is TimeoutException) {
          msgs = "Timeout Error";
       } else if(e is SocketException){
          msgs = "Check your internet/Server Connection";
       } else if(e is FormatException) {
          msgs = "Server went wrong";
       } else{
          msgs = "Cannot connect to server";
       }
       setState(() { 
        errorCheck = true;
       });
    }
  
  site() async{
    try {
      http.Response response = await http
          .get(Uri.parse("https://smssending1.000webhostapp.com/site.php"))
          .timeout(Duration(seconds: 20));
      var res = response.body;
      setState(() {
        siteUrl = res;
        url = siteUrl+"/php/balance.php";
        print(url);
      });
      // print(response.statusCode);
      if(response.statusCode == 200){
        await balanceCheck();
      } 
      else {
        setState(() { 
          errorCheck = true;
        });
        msgs = "Cannot connect to server";
      }
      
    } on Exception catch(e){
      handleApierror(e);
    }
  }
    
  error() {
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                Image.asset(
                  'images/no-internet.png',
                  height: 190.0,
                ),
                SizedBox(height: 20,),
                Center(
                  child: Text(msgs+" 😥",
                          style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                )
              ],
            ),
          ),
          SizedBox(height: 30.0),
        ],
      ),
    );
  }


  working() {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
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
      ),
    );
  }

  balanceCheck() async {
    try {
      http.Response response = await http
          .get(Uri.parse(url))
          .timeout(Duration(seconds: 20));
      var res = json.decode(response.body);
      setState(() {
        balance = res["balance"]["sms"];
      });
      if(response.statusCode == 200){
         setState(() {
          balCheck = true;
        });
      } 
      else {
        setState(() { 
          errorCheck = true;
       });
      }
    } on Exception catch(e){
        handleApierror(e);
    }
    if(errorCheck_bal) {
      setState(() {
          errorCheck = true;
      });
      Future.delayed(Duration(seconds: 5),() {
          Timer(
            Duration(),
            () => Navigator.push(
                context,
                PageRouteBuilder(
                    pageBuilder: (BuildContext context, Animation<double> animation,
                            Animation<double> secAnimation) =>
                        DashBoard())));
      });
    } else {
      Timer(
          Duration(),
          () => Navigator.push(
              context,
              PageRouteBuilder(
                  pageBuilder: (BuildContext context, Animation<double> animation,
                          Animation<double> secAnimation) =>
                      DashBoard())));
      }
  }
  
  

  Widget allLogic() {
    print(balCheck);
    print(errorCheck);
    if (balCheck == true)  {  
      return working();  
    } else if (errorCheck == true) {
      return error();
    } else {
        return Scaffold(
          body: Container(
            color: Colors.black,
            child: Column(
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
          ),
        );
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
         child: isLoading?working():allLogic()
      )
    );
  }
}
