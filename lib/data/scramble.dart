import 'dart:convert';
import 'dart:math';

import 'package:cubimer/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class Scramble {
  int time;
  String scramble;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  Scramble(this.time, this.scramble);

  Scramble.fromJson(Map<String, dynamic> json)
      : time = int.parse(json["time"]),
        scramble = json["scramble"],
        createdAt = DateTime.parse(json["created_at"]),
        updatedAt = DateTime.parse(json["updated_at"]);

  Map<String, dynamic> toJson() => {
        'time': time.toString(),
        'scramble': scramble,
        'created_at': createdAt.toString(),
        'updated_at': updatedAt.toString(),
      };

  String updatedAtStr() {
    var t = updatedAt.toLocal();
    return "${t.month}/${t.day}/${t.year} ${t.hour}:${t.minute.toString().padLeft(2, '0')}:${t.second.toString().padLeft(2, '0')}";
  }

  double getTimeSeconds() {
    return time.toDouble() / 1000;
  }

  String getTimeString() {
    return timeToString(time);
  }

  static String timeToString(int rawTime) {
    var displayTime = StopWatchTimer.getDisplayTime(rawTime);
    if (rawTime < StopWatchTimer.getMilliSecFromSecond(10)) {
      displayTime =
          StopWatchTimer.getDisplayTime(rawTime, hours: false, minute: false)
              .substring(1);
    } else if (rawTime < StopWatchTimer.getMilliSecFromMinute(1)) {
      displayTime =
          StopWatchTimer.getDisplayTime(rawTime, hours: false, minute: false);
    } else if (rawTime < StopWatchTimer.getMilliSecFromMinute(10)) {
      displayTime =
          StopWatchTimer.getDisplayTime(rawTime, hours: false).substring(1);
    } else if (rawTime < StopWatchTimer.getMilliSecFromHour(1)) {
      displayTime = StopWatchTimer.getDisplayTime(rawTime, hours: false);
    }

    return displayTime;
  }

  static int stringToTime(String timeStr) {
    if (timeStr.contains(':')) {
      final times = timeStr.split(':');

      return (double.parse(double.parse(times[1]).toStringAsFixed(2)) * 1000)
              .toInt() +
          (StopWatchTimer.getMilliSecFromMinute(int.parse(times[0])));
    } else {
      return (double.parse(double.parse(timeStr).toStringAsFixed(2)) * 1000)
          .toInt();
    }
  }

  void setTime(double seconds) {
    time = (seconds * 1000).toInt();
  }
}

class ScrambleList extends StateNotifier<List<Scramble>> {
  ScrambleList([List<Scramble>? initialScrambles])
      : super(initialScrambles ?? []);

  Future<void> add({required int time, required String scramble}) async {
    state = [...state, Scramble(time, scramble)];

    ScrambleStore.saveScrambles(state);
  }

  Future<void> edit(
      {required int time,
      required String scramble,
      required DateTime createdAt}) async {
    state = [
      for (final s in state)
        if (s.createdAt == createdAt) Scramble(time, scramble) else s,
    ];

    ScrambleStore.saveScrambles(state);
  }

  Future<void> remove(Scramble scramble) async {
    state = state.where((s) => s != scramble).toList();

    await ScrambleStore.saveScrambles(state);
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

class ScrambleStore {
  ScrambleStore();

  static Future<List<Scramble>> getScrambles() async {
    await storage.ready;
    List<dynamic> scrambles = storage.getItem('scrambles') ?? [];
    return scrambles.map((s) => Scramble.fromJson(jsonDecode(s))).toList();
  }

  static Future<void> saveScrambles(List<Scramble> scrambles) async {
    final stringScrambles =
        scrambles.map((s) => jsonEncode(s.toJson())).toList();
    storage.setItem('scrambles', stringScrambles);
  }
}
