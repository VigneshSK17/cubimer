import 'package:cubimer/data/scramble.dart';
import 'package:cubimer/main.dart';
import 'package:cubimer/widgets/edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomBar extends ConsumerStatefulWidget {
  const BottomBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomBarState();
}

class _BottomBarState extends ConsumerState<BottomBar> {
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
                        child: Text(ref.watch(currentScrambleProvider)),
                      ),
                    ),
                    Spacer(),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
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
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                if (ref.watch(scrambleListProvider).length !=
                                    0) {
                                  ref
                                      .watch(scrambleListProvider.notifier)
                                      .remove(
                                          ref.watch(scrambleListProvider).last);
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () => ref
                                          .watch(scrambleListProvider)
                                          .length !=
                                      0
                                  ? showDialog(
                                      context: context,
                                      // TODO: Set up so that it uses most recent scramble
                                      builder: (context) => EditDialog(
                                            scramble: ref
                                                .watch(scrambleListProvider)
                                                .last,
                                          ))
                                  : null,
                            ), // TODO: Add popup
                            IconButton(
                              icon: Icon(Icons.redo),
                              onPressed: () => ref
                                  .read(currentScrambleProvider.notifier)
                                  .state = CurrentScramble.genScramble(),
                            ),
                          ],
                        ))
                  ],
                ))));
  }
}
