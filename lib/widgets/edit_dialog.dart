import 'package:cubimer/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/scramble.dart';

class EditDialog extends ConsumerStatefulWidget {
  const EditDialog({super.key, required this.scramble});

  final Scramble scramble;

  @override
  ConsumerState<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends ConsumerState<EditDialog> {
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
              initialValue: widget.scramble.scramble,
            ),
            TextFormField(
              decoration: InputDecoration(),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              initialValue: widget.scramble.time.toStringAsFixed(2),
              validator: (value) => "Hi", // TODO: Check for double
            ),
          ])),
          SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            IconButton(
              // TODO: Make specific delete buttton code
              icon: Icon(Icons.delete),
              onPressed: () {
                ref.read(scrambleListProvider.notifier).remove(widget.scramble);
                Navigator.of(context).pop();
              }, // TODO: Add delete func
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
            "Last Edited: ${widget.scramble.updatedAtStr()}",
            style: TextStyle(fontWeight: FontWeight.w300),
          ))
        ]);
  }
}
