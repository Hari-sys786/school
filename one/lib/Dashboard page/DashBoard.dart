import 'dart:io';
import 'package:flutter/material.dart';
import 'package:one/Template%20Page/TemplateList.dart';
import '../Contacts page/AddContact.dart';
import '../Message page/Message.dart';
import '../Classes page/Staff.dart';
import '../Details page/Details.dart';
//import 'demoMain.dart';

void main() => runApp(DashBoard());

class DashBoard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Dash();
  }
}

class Dash extends State<DashBoard> {
  static var Clsname;
  static var a = [
    'Staff',
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
  static var village = [
    'Tpkm',
    'Duvl',
    'Vlp',
    'Rjp',
    'Prjp',
    'Rsm',
    'Brcol',
    'Gnp',
    'Mtp',
    'Glp',
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _onBackPressed() {
    return exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text("DashBoard",
              style: TextStyle(color: Colors.deepPurple[600], fontSize: 23)),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.account_box_rounded),
                color: Colors.deepPurple[800],
                iconSize: 35,
                onPressed: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (BuildContext context,
                                  Animation<double> animation,
                                  Animation<double> secAnimation) =>
                              AddContact()));
                })
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        floatingActionButton: Container(
          height: MediaQuery.of(context).size.width * 0.20,
          width: MediaQuery.of(context).size.width * 0.17,
          child: FloatingActionButton(
            onPressed: () async {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secAnimation) =>
                          Message()));
            },
            tooltip: "Send Message",
            backgroundColor: Colors.deepPurple[500],
            elevation: 0,
            child: Icon(
              Icons.message_rounded,
              size: 28,
            ),
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/background.jpg"), fit: BoxFit.cover),
          ),
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 2),
            children: [
              Container(
                  child: Padding(
                padding: EdgeInsets.all(8),
                child: Card(
                  color: Color.fromARGB(38, 170, 109, 152),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    // splashColor: Colors.red.withAlpha(30),
                    onTap: () {
                      setState(() {
                        Text("Template");
                      });
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secAnimation) =>
                                Template(),
                          ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Colors.cyan,
                        border: Border.all(
                          color: Colors.transparent,
                          width: 5,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Center(
                          child: Text(
                            "Template",
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )),
              Container(
                  child: Padding(
                padding: EdgeInsets.all(8),
                child: Card(
                  color: Color.fromARGB(38, 170, 109, 152),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    // splashColor: Colors.red.withAlpha(30),
                    onTap: () {
                      setState(() {
                        Text("All Classes");
                      });
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secAnimation) =>
                                Detail(),
                          ));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Colors.cyan,
                        border: Border.all(
                          color: Colors.transparent,
                          width: 5,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Center(
                          child: Text(
                            "Details",
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )),
              for (var i = 1; i <= a.length; i++)
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Card(
                    color: Color.fromARGB(38, 170, 109, 152),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      // splashColor: Colors.red.withAlpha(30),
                      onTap: () {
                        setState(() {
                          Text(Clsname = a[i - 1]);
                        });
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secAnimation) =>
                                  Staff(),
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          // color: Colors.cyan,
                          border: Border.all(
                            color: Colors.transparent,
                            width: 5,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Center(
                            child: Text(
                              "${a[i - 1]}",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
