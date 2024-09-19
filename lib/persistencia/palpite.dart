import 'package:floor/floor.dart';

@entity
class Palpite {
  @PrimaryKey()
  int? id;
  final String time;

  Palpite(this.id, this.time);
}
