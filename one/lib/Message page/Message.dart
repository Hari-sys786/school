import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import '../Dashboard page/DashBoard.dart';
import 'dart:convert' show json;
import 'package:http/http.dart' as http;
// import 'package:twilio_flutter/twilio_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../main.dart';

void main() => runApp(Message());

class Message extends StatefulWidget {
  @override
  MessageState createState() => MessageState();
}

class Select extends StatefulWidget {
  Select({Key? key, required this.clas}) : super(key: key);
  final String clas;
  @override
  _SelectState createState() => _SelectState();
}

class _SelectState extends State<Select> {
  var _isSelected = false;
  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.clas),
      labelStyle: TextStyle(
          color: Colors.purple, fontSize: 20, fontWeight: FontWeight.bold),
      selected: _isSelected,
      backgroundColor: Colors.white,
      onSelected: (isSelected) {
        print(isSelected);
        setState(
          () {
            _isSelected = isSelected;
            if (_isSelected) {
              MessageState.clss.add(widget.clas);
              print(MessageState.clss);
            } else {
              MessageState.clss.remove(widget.clas);
              print(MessageState.clss);
            }
            MessageState.clss = MessageState.clss.toSet().toList();
          },
        );
      },
      selectedColor: Colors.white,
    );
  }
}

// class LoadingScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       constraints: BoxConstraints.expand(),
//       decoration: const BoxDecoration(
//         image: DecorationImage(
//             image: AssetImage("images/background.jpg"), fit: BoxFit.cover),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               child: SpinKitCircle(
//                 color: Colors.red[900],
//                 size: 100,
//                 //  Text("Sending SMS\nPlease Do not press back",style: Theme.of(context).textTheme.headline5,textAlign: TextAlign.center,),
//               ),
//             ),
//             SizedBox(
//               height: 7,
//             ),
//             Container(
//               child: Text(
//                 "Sending SMS...\nPlease Do not press back",
//                 style: Theme.of(context).textTheme.headline5,
//                 textAlign: TextAlign.center,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

class MessageState extends State<Message> {
  // final controller = TestController();
  var bal = MyHomePageState.balance;
  late TextEditingController msgController;
  // late TwilioFlutter twilioFlutter;
  static List<String> clss = [];
  List<int> storeNum = [];
  var extractedData;
  var name = Dash.a;
  bool isLoadingloader = false;
  void initState() {
    msgController = TextEditingController();
    super.initState();
    //controller.getData();
    data();
    //msg();
  }

  showLoading(data) {
    showDialog(
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SpinKitWave(
                    size: 50,
                    color: Colors.limeAccent,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    data == "sms"
                        ? "\nSending SMS...\nPlease Do not press back"
                        : "",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .merge(TextStyle(color: Colors.white)),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        );
      },
      context: context,
    );
  }

//data() function is used to get data from firebase
  data() async {
    var res = await http.get(Uri.parse(
        "https://kenndy-a2554-default-rtdb.asia-southeast1.firebasedatabase.app/Staff.json?"));
    //print(json.decode(res.body));
    extractedData = json.decode(res.body) as Map<String, dynamic>;
    //return _processResponse(res);
  }

//msg() function is used to send sms when send button is trigered
  msg() {
    extractedData.forEach((name, staff) {
      for (var i = 0; i < clss.length; i++) {
        if (staff['value'] == clss[i]) {
          storeNum.add(staff['number']);
        }
      }
    });
    var c = storeNum.toSet().toList().length;
    print("Contacts count: $c");
    if (storeNum.isEmpty == true) {
      var msgs = "No Data Found";
      showToast(msgs);
    } else {
      smsapi();
    }
    //clss.clear();
  }

//smsapi() function is used to call textlocal api
  smsapi() async {
    showLoading("sms");
    //var num = storeNum.toSet(); http://192.168.55.103/message.php
    final Map<String, dynamic> bodys = {
      "message": msgController.text,
      "number": storeNum.toSet().toString()
    };
    try {
      http.Response response = await http
          .post(
            Uri.parse("https://smssending1.000webhostapp.com/index.php"),
            body: bodys,
          )
          .timeout(Duration(seconds: 20));
      //print(response.statusCode);
      return _processResponse(response);
    } on TimeoutException {
      var msgs = "Timeout Error";
      showToast(msgs);
      Navigator.pop(context);
    } on SocketException {
      var msgs = "Turn on internet connection";
      showToast(msgs);
      Navigator.pop(context);
    } on FormatException {
      var msgs = "Something went wrong";
      showToast(msgs);
      Navigator.pop(context);
    }
  }

//api errors handling
  dynamic _processResponse(response) {
    print(response.body);
    switch (response.statusCode) {
      case 404:
        print(response.statusCode);
        var msgs = "Server Error";
        showToast(msgs);
        Navigator.pop(context);
        break;
      case 503:
        var msgs = "Server Busy";
        showToast(msgs);
        Navigator.pop(context);
        break;
      case 500:
        var msgs = "Internal Server Error";
        showToast(msgs);
        Navigator.pop(context);
        break;
    }
    var res = json.decode(response.body);
    var res1 = json.decode(response.body)["errors"];
    if (res["status"] == "success") {
      clss.clear();
      setState(() {
        MyHomePageState.balance = res["balance"];
      });
      var msgs = "SMS sent successfully ${res["balance"]}";
      showToast(msgs);
      sleep(Duration(seconds: 2));
      Navigator.pop(context);
    } else if (res1[0]["code"] == 204) {
      var msgs = "Invalid message content";
      showToast(msgs);
      sleep(Duration(seconds: 2));
      Navigator.pop(context);
    } else if (res1[0]["code"] == 7) {
      var msgs = "Insufficient credits";
      showToast(msgs);
      sleep(Duration(seconds: 2));
      Navigator.pop(context);
    } else if (res1[0]["code"] == 80) {
      var msgs = "Invalid Template";
      showToast(msgs);
      sleep(Duration(seconds: 2));
      Navigator.pop(context);
    } else if (msgController.text.isEmpty == true || storeNum.isEmpty == true) {
      var msgs = "Verify the details provided";
      showToast(msgs);
      Navigator.pop(context);
    } else {
      var msgs = "Unexpected Error";
      showToast(msgs);
      Navigator.pop(context);
    }
    storeNum.clear();
    if (res['status'] == "success") {
      //print("a");
      bal = res["balance"];
      Navigator.pop(context);
    }
  }

  Future<bool> _deleteValues() async {
    clss.clear();
    Navigator.pop(context);
    return true;
  }

  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _deleteValues,
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Text('Send Message'),
                Spacer(),
                Text(bal.toString()),
              ],
            ),
            backgroundColor: Colors.deepPurple,
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Wrap(
                      spacing: 2.0,
                      runSpacing: 3.0,
                      children: [
                        for (var i in name)
                          Select(
                            clas: '$i',
                          ),
                      ],
                    ),
                  )),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: msgController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Send Message",
                          hintText: "Enter Message",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 48,
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            msg();
                          },
                          child: Text(
                            "Send",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              elevation: 25,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                        ),
                      ),
                      Container(
                        height: 48,
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            clss.clear();
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              elevation: 25,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void showToast(msgs) => Fluttertoast.showToast(
        msg: msgs,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
      );
}
