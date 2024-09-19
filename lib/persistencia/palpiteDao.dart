import 'package:floor/floor.dart';
import 'package:tabalho2/persistencia/palpite.dart';

@dao
abstract class PalpiteDao {
  @Query('SELECT * FROM Palpite WHERE id = :id')
  Stream<Palpite?> getPalpite(int id);

  @insert
  Future<void> insertPalpite(Palpite palpite);

  @Query("DELETE FROM Palpite WHERE id = :id")
  Future<void> deletePalpite(int id);
}
