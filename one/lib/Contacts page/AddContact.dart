import 'dart:io';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../Dashboard page/DashBoard.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(AddContact());

class AddContact extends StatefulWidget {
  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  var clas = Dash.a;
  var village = Dash.village;
  TextEditingController? _nameController, _numberController;
  late DatabaseReference _ref;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _numberController = TextEditingController();
    _ref = FirebaseDatabase.instance.ref().child('Staff');
  }

  String? _value;
  String? _typeSelected;
  saveContact() async {
    String name = _nameController!.text;
    int number = int.parse('+91' + _numberController!.text);
    Map<String, dynamic> staff = {
      'name': name,
      'number': number,
      'type': _typeSelected,
      'value': _value,
    };

    _ref.push().set(staff).then((value) {
      var msgs = "Saved successfully";
      showToast(msgs);
      sleep(Duration(seconds: 1));
      Navigator.pop(context);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Contacts"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 130,
                    child: Image.asset('images/Logo.png')),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.words,
                controller: _nameController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: "Enter Name",
                  prefixIcon: Icon(Icons.account_circle, size: 37),
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 22.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: _numberController,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "Enter Phone Number",
                    counterText: "",
                    prefixIcon: Icon(Icons.phone, size: 37),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                    ),
                  ),
                )),
            SizedBox(height: 15),
            Column(
              children: [
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(right: 20)),
                    Container(
                      height: 60,
                      child: DropdownButton(
                        value: _typeSelected,
                        items: [
                          for (var i = 1; i <= 10; i++)
                            DropdownMenuItem(
                                child: Text(
                                  "${village[i - 1]}",
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.black),
                                ),
                                value: "${village[i - 1]}"),
                        ],
                        onChanged: (dynamic value) {
                          setState(
                            () {
                              _typeSelected = value;
                            },
                          );
                        },
                        hint: Text(
                          'Village ',
                          style: TextStyle(fontSize: 22, color: Colors.black),
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                        child: DropdownButton(
                      value: _value,
                      items: [
                        for (var i = 1; i <= 12; i++)
                          DropdownMenuItem(
                              child: Text(
                                "${clas[i - 1]}",
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black),
                              ),
                              value: "${clas[i - 1]}"),
                      ],
                      onChanged: (dynamic value) {
                        setState(() {
                          _value = value;
                        });
                      },
                      hint: Text(
                        'Class',
                        style: TextStyle(fontSize: 22, color: Colors.black),
                      ),
                    )),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: 48,
                  width: 150,
                  child: ElevatedButton(
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      //print((_numberController?.value.text.toString().length));
                      if (_nameController != null &&
                          _numberController != null &&
                          (_numberController?.value.text.toString().length) ==
                              10 &&
                          _typeSelected != null &&
                          _value != null) {
                        saveContact();
                      } else {
                        var msgs = "Fill all the details correctly";
                        showToast(msgs);
                      }
                    },
                  ),
                ),
                Container(
                  height: 48,
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

void showToast(msgs) => Fluttertoast.showToast(
      msg: msgs,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      //backgroundColor: Colors.green
    );
