import 'package:auto_size_text/auto_size_text.dart';
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
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Expanded(
                    // child: Align(
                    // fit: BoxFit.contain,
                    // alignment: Alignment.centerLeft,
                    // child: FittedBox(
                    // FittedBox(
                    //     fit: BoxFit.fitWidth,
                    //     child: Text(ref.watch(currentScrambleProvider))),
                    // )),

                    // fit: BoxFit.fitWidth,
                    Expanded(
                        child: AutoSizeText(
                      ref.watch(currentScrambleProvider),
                      style: TextStyle(fontSize: 50),
                      minFontSize: 16,
                    )),
                    // ),
                    // const Spacer(),
                    // ConstrainedBox(
                    //     constraints: BoxConstraints(maxWidth: 100),
                    //     child: SizedBox()),
                    const Spacer(),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: FutureBuilder(
                            future: storage.ready,
                            builder: (_, __) => Wrap(
                                  alignment: WrapAlignment.spaceAround,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    DropdownButton(
                                      items: const [
                                        DropdownMenuItem(child: Text("3x3"))
                                      ],
                                      onChanged: (value) => (),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        if (ref
                                            .watch(scrambleListProvider)
                                            .isNotEmpty) {
                                          ref
                                              .watch(
                                                  scrambleListProvider.notifier)
                                              .remove(ref
                                                  .watch(scrambleListProvider)
                                                  .last);
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () => ref
                                              .watch(scrambleListProvider)
                                              .isNotEmpty
                                          ? showDialog(
                                              context: context,
                                              // TODO: Set up so that it uses most recent scramble
                                              builder: (context) => EditDialog(
                                                    scramble: ref
                                                        .watch(
                                                            scrambleListProvider)
                                                        .last,
                                                  ))
                                          : null,
                                    ), // TODO: Add popup
                                    IconButton(
                                      icon: const Icon(Icons.redo),
                                      onPressed: () => ref
                                              .read(currentScrambleProvider
                                                  .notifier)
                                              .state =
                                          CurrentScramble.genScramble(),
                                    ),
                                  ],
                                )))
                  ],
                ))));
  }
}
