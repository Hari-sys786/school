import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:one/Template%20Page/Model.dart';

class Detailstemplate extends StatelessWidget {
  final smsTemplate smstemp;
  Detailstemplate({required this.smstemp});
  @override
  Widget build(BuildContext context) {
    final key = new GlobalKey<ScaffoldState>();
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: Text(smstemp.title),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "${smstemp.title} Template",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.deepPurple),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: GestureDetector(
                child: Text(
                  smstemp.description,
                  //textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                onLongPress: () {
                  Clipboard.setData(
                      new ClipboardData(text: smstemp.description));
                  var msgs = "Description is copied to clipboard";
                   showToast(msgs);
                },
              ),
            ),
            Divider(
              height: 30,
            ),
            Text(
              "${smstemp.title} Example",
              textAlign: TextAlign.end,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.deepPurple),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: GestureDetector(
                child: Text(
                  smstemp.example,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                onLongPress: () {
                  Clipboard.setData(
                      new ClipboardData(text: smstemp.example));
                  var msgs = "Example is copied to clipboard";
                   showToast(msgs);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

void showToast(msgs) => Fluttertoast.showToast(
        msg: msgs,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
      );