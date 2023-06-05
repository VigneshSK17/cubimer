import 'package:cubimer/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/scramble.dart';

class EditDialog extends ConsumerStatefulWidget {
  const EditDialog({super.key, required this.scramble});

  final Scramble scramble;

  @override
  ConsumerState<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends ConsumerState<EditDialog> {
  TextEditingController scrambleController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    scrambleController = TextEditingController(text: widget.scramble.scramble);
    timeController =
        TextEditingController(text: widget.scramble.time.toStringAsFixed(2));
  }

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
              controller: scrambleController,
              textAlign: TextAlign.center,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("^[A-Z' ]+\$"))
              ],
            ),
            TextFormField(
              controller: timeController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
              ],
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
                var newScramble = scrambleController.text;
                var newTime =
                    double.parse(timeController.text).toStringAsFixed(2);

                if (widget.scramble.scramble != newScramble ||
                    widget.scramble.time.toStringAsFixed(2) != newTime) {
                  ref.read(scrambleListProvider.notifier).edit(
                      id: widget.scramble.id,
                      time: double.parse(newTime),
                      scramble: newScramble);
                }
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
