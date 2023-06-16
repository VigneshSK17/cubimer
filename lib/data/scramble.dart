import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class Scramble {
  int time;
  String scramble;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  Scramble(this.time, this.scramble);

  String updatedAtStr() {
    var t = updatedAt.toLocal();
    return "${t.month}/${t.day}/${t.year} ${t.hour}:${t.minute.toString().padLeft(2, '0')}:${t.second.toString().padLeft(2, '0')}";
  }

  double getTimeSeconds() {
    return time.toDouble() / 1000;
  }

  String getTimeString() {
    return getTimeSeconds().toStringAsFixed(2);
  }

  static int convertTimeString(String timeStr) {
    return (double.parse(double.parse(timeStr).toStringAsFixed(2)) * 1000)
        .toInt();
  }

  void setTime(double seconds) {
    time = (seconds * 1000).toInt();
  }
}

class ScrambleList extends StateNotifier<List<Scramble>> {
  ScrambleList([List<Scramble>? initialScrambles])
      : super(initialScrambles ?? []);

  void add({required int time, required String scramble}) {
    state = [...state, Scramble(time, scramble)];
  }

  void edit(
      {required int time,
      required String scramble,
      required DateTime createdAt}) {
    state = [
      for (final s in state)
        if (s.createdAt == createdAt) Scramble(time, scramble) else s,
    ];
  }

  void remove(Scramble scramble) {
    state = state.where((s) => s != scramble).toList();
  }
}

class CurrentScramble extends StateNotifier<String> {
  CurrentScramble() : super(genScramble());

  static String genScramble() {
    const moves = [
      "U",
      "D",
      "R",
      "L",
      "F",
      "B",
      "U'",
      "D'",
      "R'",
      "L'",
      "F'",
      "B'",
      "U2",
      "D2",
      "R2",
      "L2",
      "F2",
      "B2"
    ];
    const cancels = {
      "U": "U'",
      "D": "D'",
      "R": "R'",
      "L": "L'",
      "F": "F'",
      "B": "B'"
    };
    const opposites = {
      "U": "D",
      "R": "L",
      "F": "B",
      "U'": "D'",
      "R'": "L'",
      "F'": "B'",
      "U2": "D2",
      "R2": "L2",
      "F2": "B2"
    };

    var scramble = [];
    var doublesCount = {"U2": 0, "D2": 0, "R2": 0, "L2": 0, "F2": 0, "B2": 0};

    var i = 0;
    while (scramble.length < 15) {
      var move = moves[Random().nextInt(moves.length)];
      var isValid = true;

      if (doublesCount.containsKey(move)) {
        if (doublesCount[move]! > 1) {
          isValid = false;
        }
      }

      if (i != 0) {
        if (move == scramble.last) {
          isValid = false;
        }

        if (cancels.containsKey(move)) {
          if (cancels[move] == scramble.last) {
            isValid = false;
          }
        } else {
          var key = cancels.keys
              .firstWhere((k) => cancels[k] == move, orElse: () => "");
          if (key == scramble.last) {
            isValid = false;
          }
        }

        if (opposites.containsKey(move)) {
          if (opposites[move] == scramble.last) {
            isValid = false;
          }
        } else {
          var key = opposites.keys
              .firstWhere((k) => opposites[k] == move, orElse: () => "");
          if (key == scramble.last) {
            isValid = false;
          }
        }
      }

      if (isValid) {
        scramble.add(move);
        i++;
      }
    }

    return scramble.join(" ");
  }
}
