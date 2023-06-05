import 'package:cubimer/main.dart';
import 'package:cubimer/widgets/edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScramblesDrawer extends ConsumerStatefulWidget {
  const ScramblesDrawer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScramblesDrawerState();
}

class _ScramblesDrawerState extends ConsumerState<ScramblesDrawer> {
  @override
  Widget build(BuildContext context) {
    final scrambles = ref.watch(scrambleListProvider);

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
                for (final s in scrambles)
                  DataRow(
                      cells: [
                        DataCell(Text(s.id.toString())),
                        DataCell(Text(s.time.toStringAsFixed(2))),
                        DataCell(Text(' '))
                      ],
                      onLongPress: () => showDialog(
                          context: context,
                          builder: (context) => EditDialog(scramble: s)))
              ])
            ])));
  }
}
