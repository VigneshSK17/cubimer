import 'package:cubimer/widgets/edit_dialog.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<StatefulWidget> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        child: Center(
            child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      // TODO: Fix font sizing
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text("F D L R U B U' R' L' D' F'"),
                      ),
                    ),
                    Spacer(),
                    Expanded(
                        child: Wrap(
                      alignment: WrapAlignment.spaceAround,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        // TODO: Fix dropdown
                        DropdownButton(
                          items: [DropdownMenuItem(child: Text("3x3"))],
                          onChanged: (value) =>
                              print("hi"), // TODO: Change it to state
                        ),
                        Icon(Icons.delete),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => showDialog(
                              context: context,
                              builder: (context) => EditDialog()),
                        ), // TODO: Add popup
                        Icon(Icons.redo)
                      ],
                    ))
                  ],
                ))));
  }
}
