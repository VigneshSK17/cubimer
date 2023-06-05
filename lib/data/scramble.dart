class Scramble {
  int id;
  double time;
  String scramble;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  Scramble(this.id, this.time, this.scramble);

  String createdAtStr() {
    var t = createdAt.toLocal();
    return "${t.month}-${t.day}-${t.year} ${t.hour}:${t.minute}:${t.second}";
  }
}
