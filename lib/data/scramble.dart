import 'package:flutter_riverpod/flutter_riverpod.dart';

class Scramble {
  int id;
  double time;
  String scramble;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  Scramble(this.id, this.time, this.scramble);

  String updatedAtStr() {
    var t = updatedAt.toLocal();
    return "${t.month}/${t.day}/${t.year} ${t.hour}:${t.minute.toString().padLeft(2, '0')}:${t.second.toString().padLeft(2, '0')}";
  }
}

class ScrambleList extends StateNotifier<List<Scramble>> {
  ScrambleList([List<Scramble>? initialScrambles])
      : super(initialScrambles ?? []);

  void add({required double time, required String scramble}) {
    state = [
      ...state,
      Scramble(
          state.isEmpty ? 1 : state[state.length - 1].id + 1, time, scramble)
    ];
  }

  void edit({required int id, required double time, required String scramble}) {
    state = [
      for (final s in state)
        if (s.id == id) Scramble(id, time, scramble) else s,
    ];
  }

  void remove(Scramble scramble) {
    state = state.where((s) => s.id != scramble.id).toList();
  }
}
