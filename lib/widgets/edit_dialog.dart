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
        TextEditingController(text: widget.scramble.getTimeString());
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        title: const Text("Edit Scramble"),
        contentPadding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        children: [
          Form(
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
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^[0-9:.]+$'))
              ],
            ),
          ])),
          const SizedBox(height: 10),
          FutureBuilder(
              future: storage.ready,
              builder: (_, __) =>
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        ref
                            .read(scrambleListProvider.notifier)
                            .remove(widget.scramble);
                        Navigator.of(context).pop();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () {
                        var newScramble = scrambleController.text;
                        var newTime =
                            Scramble.stringToTime(timeController.text);

                        if (widget.scramble.scramble != newScramble ||
                            widget.scramble.time != newTime) {
                          ref.read(scrambleListProvider.notifier).edit(
                              time: newTime,
                              scramble: newScramble,
                              createdAt: widget.scramble.createdAt);
                        }
                        Navigator.of(context).pop();
                      },
                    )
                  ])),
          Center(
              child: Text(
            "Last Edited: ${widget.scramble.updatedAtStr()}",
            style: const TextStyle(fontWeight: FontWeight.w300),
          ))
        ]);
  }
}
