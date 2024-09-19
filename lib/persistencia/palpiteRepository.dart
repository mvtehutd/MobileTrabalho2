import 'package:tabalho2/persistencia/palpite.dart';
import 'package:tabalho2/persistencia/palpiteDao.dart';

import 'appDatabase.dart';

class PalpiteRepository {
  late AppDatabase database;
  late PalpiteDao palpiteDao;

  Future<void> initialize() async {
    database =
    await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    palpiteDao = database.personDao;
  }

  Future<void> inserirPalpite(Palpite palpite) => palpiteDao.insertPalpite(palpite);

  Future<void> removerPalpite(int id) => palpiteDao.deletePalpite(id);

  Stream<Palpite?> obterPalpite(int id) => palpiteDao.getPalpite(id);
}