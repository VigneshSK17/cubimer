import 'package:cubimer/widgets/edit_dialog.dart';
import 'package:flutter/material.dart';

class ScramblesDrawer extends StatefulWidget {
  const ScramblesDrawer({super.key});

  @override
  State<StatefulWidget> createState() => _ScramblesDrawerState();
}

class _ScramblesDrawerState extends State<ScramblesDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0))),
        child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(children: [
              // Text("Scrambles"),
              // Divider(),
              DataTable(columns: [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Time')),
                DataColumn(label: Text('Ao5'))
              ], rows: [
                DataRow(
                    cells: [
                      DataCell(Text('1')),
                      DataCell(Text('5.55')),
                      DataCell(Text(' ')),
                    ],
                    onLongPress: () => showDialog(
                        context: context, builder: (context) => EditDialog()))
              ])
            ])));
  }
}
