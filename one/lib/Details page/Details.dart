import 'dart:async';
import 'dart:io';

import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:one/Dashboard page/DashBoard.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert' show json;
import 'package:http/http.dart' as http;
import '../Contacts page/AddContact.dart';

class Detail extends StatefulWidget {
  @override
  DetailClasses createState() => DetailClasses();
}

class DetailClasses extends State<Detail> {
  late Query _ref;
  String? _typeSelected;
  var selectName;
  late TextEditingController msgController;
  List<int> Clskeyss = [];
  List<int> All = [];
  List<int> contacts = [];
  //var storeNum = [];
  var extractedData;
  var a = Dash.a;
  @override
  void initState() {
    msgController = TextEditingController();
    super.initState();
    _ref = FirebaseDatabase.instance.ref().child('Staff').orderByChild('name');
    firebaseData();
  }

  firebaseData() async {
    var res = await http.get(Uri.parse(
        "https://kenndy-a2554-default-rtdb.asia-southeast1.firebasedatabase.app/Staff.json?"));
    //print(json.decode(res.body));
    extractedData = json.decode(res.body) as Map<String, dynamic>;
  }

  // displaying the data based on class selection
  display(className) {
    //print(className);
    // print(staff['value']);
    return className != null
        ? FirebaseAnimatedList(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            query: _ref,
            defaultChild: Center(child: CircularProgressIndicator()),
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              Map staff = snapshot.value as Map<dynamic, dynamic>;
              return _buildContactItem(className, staff: staff);
            },
          )
        : Container(
            child: Center(child: Text("Select the class from the dropdown")),
          );
  }

  // storing all numbers in All list
  abc(name, staff) {
    if (All.isEmpty) {
      //print('aaaaalllll' + name);
      extractedData.forEach((name, staff) {
        for (var i = 0; i < a.length; i++) {
          if (staff['value'] == a[i]) {
            //print(a[i]);
            All.add(staff['number']);
          }
        }
      });
      //print(All.length);
    }
    // else {
    //   print("check repetation");
    // }
    return false;
  }

  // checkbox list format similar to staff
  _buildContactItem(name, {required Map staff}) {
    return staff['value'] == name
        ? InkWell(
            child: Container(
                child: CheckboxListTile(
              title: Text(staff['name'],
                  style: TextStyle(fontSize: 20, color: Colors.black)),
              subtitle: Text('+' + staff['number'].toString(),
                  style: TextStyle(fontSize: 20, color: Colors.black54)),
              secondary: CircleAvatar(
                backgroundImage: AssetImage('images/contacticon.jpg'),
                radius: 30,
              ),
              checkColor: Colors.white,
              activeColor: Colors.blue,
              //tileColor: Colors.blue,
              selected: abc(name, staff),
              value: Clskeyss.contains(staff['number']) ? false : true,
              onChanged: (value) {
                setState(() {
                  // print(staff['key']);
                  // this._value = value!;
                  _onCategorySelected(value, staff['number']);
                  //print(All);
                  //value = true;
                });

                //print(All);
              },
            )),
          )
        : Container();
  }

  //toogle checkbox and adding removing the selected contacts
  _onCategorySelected(select, key) {
    if (select == false) {
      Clskeyss.add(key);
    } else {
      Clskeyss.remove(key);
    }
    // print("clsssss");
    // print(Clskeyss);
  }

  //textfield for entering msg
  _sendSms(All, Clskeyss) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text("Sending Sms for selected people"),
            content: TextField(
              controller: msgController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Send Message",
                hintText: "Enter Message",
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  testing();
                },
                child: Center(
                  child: Text(
                    'Send',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple,
                    elevation: 25,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
              )
            ],
          );
        });
  }

  // logic for selected contacts and calling function of sms api
  testing() {
    var set1 = Set.from(All);
    // print(set1);
    var set2 = Set.from(Clskeyss);
    // print(set2);
    contacts = List.from(set1.difference(set2));
    //print(contacts.length);
    //print(bodyy);
    _sendingSms();
    // Navigator.pop(context);
  }

  // sending sms api logic
  _sendingSms() async {
    showLoading();
    final Map<String, dynamic> bodys = {
      "message": msgController.text,
      "number": contacts.toSet().toString()
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
      contacts.clear();
      All.clear();
      Clskeyss.clear();
      var msgs = "SMS sent successfully ${res["balance"]}";
      showToast(msgs);
      sleep(Duration(seconds: 2));
      Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secAnimation) =>
                DashBoard(),
          ));
    } else if (res1[0]["code"] == 204) {
      var msgs = "Invalid message content";
      showToast(msgs);
      sleep(Duration(seconds: 2));
      Navigator.pop(context);
    } else if (res1[0]["code"] == 80) {
      var msgs = "Invalid Template";
      showToast(msgs);
      sleep(Duration(seconds: 2));
      Navigator.pop(context);
    } else if (msgController.text.isEmpty == true || contacts.isEmpty == true) {
      var msgs = "Verify the details provided";
      showToast(msgs);
      Navigator.pop(context);
    } else {
      var msgs = "Unexpected Error";
      showToast(msgs);
      Navigator.pop(context);
    }
    contacts.clear();
    if (res['status'] == "success") {
      //print("a");
      var bal = res["balance"];
      Navigator.pop(context);
    }
  }

  // loading screen for sending sms
  showLoading() {
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
                    "\nSending SMS...\nPlease Do not press back",
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
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

  //going to back to remove list data logic
  Future<bool> _deleteValues() async {
    All.clear();
    Clskeyss.clear();
    contacts.clear();
    print(All);
    print(Clskeyss);
    print(contacts);
    Navigator.pop(context);
    return true;
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _deleteValues,
      child: Scaffold(
          appBar: AppBar(
            title: Text('All Classes'),
            backgroundColor: Colors.deepPurple,
          ),
          body: SingleChildScrollView(
            child: Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 10),
                ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                    isExpanded: true,
                    value: _typeSelected,
                    items: [
                      for (var i = 1; i <= a.length; i++)
                        DropdownMenuItem(
                            child: Center(
                              child: Text(
                                "${a[i - 1]}",
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black),
                              ),
                            ),
                            value: "${a[i - 1]}"),
                    ],
                    onChanged: (dynamic value) {
                      setState(
                        () {
                          _typeSelected = value;
                          selectName = value;
                        },
                      );
                    },
                    style: Theme.of(context).textTheme.titleMedium,
                    hint: Center(
                      child: Text(
                        'Select Class ',
                        style: TextStyle(fontSize: 22, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: display(_typeSelected),
                ),
                // SizedBox(height: 10),
                Container(
                    height: 40,
                    width: 320,
                    child: _typeSelected != null
                        ? Container(
                            child: ElevatedButton(
                                child: Text("Submit",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20)),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.deepPurple,
                                    elevation: 25,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30))),
                                onPressed: () {
                                  _sendSms(All, Clskeyss);
                                }),
                          )
                        : Container()),
                SizedBox(height: 10)
              ],
            )),
          )),
    );
  }
}
