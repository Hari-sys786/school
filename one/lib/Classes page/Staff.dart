import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../Contacts page/EditContact.dart';
import '../Dashboard page/DashBoard.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class Staff extends StatefulWidget {
  @override
  StaffState createState() {
    return StaffState();
  }
}

bool search = false;
bool isSelected = false;
var call = false;

class StaffState extends State<Staff> {
  var Clsname = Dash.Clsname;
  var Clskeys = [];
  late Query _ref;
  var mycolor = Colors.white;
  Map<int, bool> selectedFlag = {};
  DatabaseReference del = FirebaseDatabase.instance.ref().child('Staff');
  @override
  void initState() {
    super.initState();
    _ref = FirebaseDatabase.instance.ref().child('Staff').orderByChild('name');
  }

  _confirmDeleteDialog({required Map staff}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text("Delete ${staff['name']}"),
              content: Text(
                  "The contact ${staff['name']} will be deleted from your device"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel',
                      style: TextStyle(color: Colors.blue, fontSize: 20)),
                ),
                TextButton(
                    onPressed: () {
                      del
                          .child(staff['key'])
                          .remove()
                          .whenComplete(() => Navigator.pop(context));
                    },
                    child: Text('Delete',
                        style: TextStyle(color: Colors.red, fontSize: 20))),
              ]);
        });
  }

  calling({required Map staff}) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text("Calling ${staff['name']}"),
              content: Text('Calling +${staff['number']} from your device'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel',
                      style: TextStyle(color: Colors.red, fontSize: 20)),
                ),
                TextButton(
                    onPressed: () async{
                      var num = staff['number'].toString();
                      await FlutterPhoneDirectCaller.callNumber('+' + num);
                     // launch('tel:' + '+' + num);
                      Navigator.pop(context);
                    },
                    child: Text('Call',
                        style: TextStyle(color: Colors.blue, fontSize: 20))),
              ]);
        });
  }

  Widget _buildContactItem({required Map staff}) {
    return staff['value'] == Clsname
        ? Container(
            child: Slidable(
              child: ListTile(
                  title: Text(staff['name'], style: TextStyle(fontSize: 20)),
                  subtitle: Text('+' + staff['number'].toString(),
                      style: TextStyle(fontSize: 20)),
                  trailing: Text(staff['type'], style: TextStyle(fontSize: 23)),
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('images/contacticon.jpg'),
                    radius: 30,
                  ),
                  onLongPress: () => {
                     calling(staff: staff) 
                  }),
              endActionPane: ActionPane(motion: ScrollMotion(), children: [
                SlidableAction(
                  flex: 1,
                  backgroundColor: Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                  onPressed: (BuildContext context) {
                    _confirmDeleteDialog(staff: staff);
                  },
                ),
                SlidableAction(
                  backgroundColor: Color(0xFF0392CF),
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'Edit',
                  onPressed: (BuildContext context) {
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secAnimation) =>
                                EditContact(staffKey: staff['key'])));
                  },
                ),
              ]),
            ),
          )
        : Container();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !search
            ? Text(Clsname)
            : TextField(
                decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: "Search ...",
                    hintStyle: TextStyle(color: Colors.white)),
                onChanged: (text) {
                  null;
                },
              ),
        actions: [
          !search
              ? IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      search = !search;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      search = !search;
                    });
                  },
                )
        ],
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        child: FirebaseAnimatedList(
          query: _ref,
          defaultChild: Center(child: CircularProgressIndicator()),
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map staff = snapshot.value as Map<dynamic, dynamic>;
            // this if is to perform delete and edit
            if (staff['value'] == Clsname) {
              staff['key'] = snapshot.key;
            }
            return _buildContactItem(staff: staff);
          },
        ),
      ),
    );
  }
}
