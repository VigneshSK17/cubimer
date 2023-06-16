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
            child: Scrollbar(
                child:
                    // Text("Scrambles"),
                    // Divider(),
                    SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(columns: [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Time')),
                          DataColumn(label: Text('Ao5'))
                        ], rows: [
                          // for (final s in scrambles)
                          for (int i = 0; i < scrambles.length; i++)
                            DataRow(
                                cells: [
                                  DataCell(Text((i + 1).toString())),
                                  DataCell(Text(
                                      (scrambles[i].time.toDouble() / 1000.0)
                                          .toStringAsFixed(2))),
                                  DataCell(Text(' '))
                                ],
                                onLongPress: () => showDialog(
                                    context: context,
                                    builder: (context) =>
                                        EditDialog(scramble: scrambles[i])))
                        ])))));
  }
}
