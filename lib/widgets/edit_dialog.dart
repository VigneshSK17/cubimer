import 'package:flutter/material.dart';

class EditDialog extends StatefulWidget {
  const EditDialog({super.key});

  @override
  State<StatefulWidget> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        title: Text("Edit Scramble"),
        contentPadding: EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        children: [
          Form(
              // TODO: Add formkey for button
              child: Column(children: [
            TextFormField(
              decoration: InputDecoration(),
              textAlign: TextAlign.center,
              initialValue: "F D L R U B U' R' L' D' F'",
            ),
            TextFormField(
              decoration: InputDecoration(),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              initialValue: "5.55",
              validator: (value) => "Hi", // TODO: Check for double
            ),
          ])),
          SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            IconButton(
              // TODO: Make specific delete buttton code
              icon: Icon(Icons.delete),
              onPressed: () => print("Delete"), // TODO: Add delete func
            ),
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                // TODO: Add save func using formkey
                print("Saved changes");
                Navigator.of(context).pop();
              },
            )
          ]),
          Center(
              child: Text(
            "Last Edited: 1-2-23",
            style: TextStyle(fontWeight: FontWeight.w300),
          ))
        ]);
  }
}
