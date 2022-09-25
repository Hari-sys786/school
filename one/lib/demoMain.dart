import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:one/Dashboard%20page/DashBoard.dart';
import 'package:one/Contacts%20page/EditContact.dart';

class Staff extends StatefulWidget {
  Staff.fromJson(job);

  @override
  _StaffState createState() => _StaffState();
}

bool search = false;
bool isSelected = false;
bool isSelection = false;
//int count = 0;

class _StaffState extends State<Staff> {
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
              content: Text("This will delete the contact from your device"),
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
                        style: TextStyle(color: Colors.blue, fontSize: 20))),
              ]);
        });
  }

  checkSelect(isSelected) {
    isSelected = true;
  }

  _buildSelectIcon(isSelection) {
    print(isSelection);
    if (isSelection) {
      return Icon(
        isSelection ? Icons.check_box : Icons.check_box_outline_blank,
      );
    } else {
      return CircleAvatar(
        backgroundImage: AssetImage('images/image.jpg'),
        radius: 30,
      );
    }
  }

  checkbox(isSelected) {
    setState(() {
      isSelected = !isSelected;
      _buildSelectIcon(isSelected);
      //print(isSelected);
    });
    // isSelection = isSelected;
    // print(isSelection);
  }

  Widget _buildContactItem({required Map staff}) {
    return staff['value'] == Clsname
        ? Expanded(
          child: Slidable(
              child: Row(
                children: [
                  isSelected
                      ? Checkbox(
                          value: true,
                          onChanged: (value) {
                            print(value);
                          })
                      : Container(
                          child: CircleAvatar(
                          backgroundImage: AssetImage('images/image.jpg'),
                          radius: 30,
                        )),
                  SizedBox(
                    child: ListTile(
                      onLongPress: checkSelect(isSelected),
                      title: Text(staff['name'], style: TextStyle(fontSize: 20)),
                      subtitle: Text('+' + staff['number'].toString(),
                          style: TextStyle(fontSize: 20)),
                      trailing: Text(staff['type'], style: TextStyle(fontSize: 23)),
                      leading: _buildSelectIcon(isSelection),
                    ),
                  ),
                ],
              ),
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
        backgroundColor: Colors.purple,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: FirebaseAnimatedList(
          query: _ref,
          defaultChild: Center(child: CircularProgressIndicator()),
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map staff = snapshot.value as Map<dynamic, dynamic>;
            // if (staff['value'] == Clsname) {
            //   staff['key'] = snapshot.key;
            // }
            // Clskeys.add(staff['key']);
            // count = Clskeys.length;
            // Clskeys.clear();
            // staff['key'] = snapshot.key;
            // print(count);
            return _buildContactItem(staff: staff);
          },
        ),
      ),
    );
  }
}
