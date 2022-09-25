import 'package:flutter/material.dart';
import 'package:one/Template%20Page/Details_templates.dart';
import 'package:one/Template%20Page/Model.dart';

class Template extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SMS Templates"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
          itemCount: templateList.length,
          itemBuilder: (BuildContext context, index) {
            smsTemplate temp = templateList[index];
            return Card(
              child: ListTile(
                title: Text(temp.title,style: TextStyle(fontSize: 22)),
                trailing: Icon(Icons.arrow_forward_rounded),
                onTap: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (BuildContext context,
                                  Animation<double> animation,
                                  Animation<double> secAnimation) =>
                              Detailstemplate(smstemp: temp,)));
                },
              ),
            );
          }),
    );
  }
}
