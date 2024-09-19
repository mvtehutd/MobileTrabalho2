// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:tabalho2/persistencia/palpite.dart';
import 'package:tabalho2/persistencia/palpiteDao.dart';

part 'appDatabase.g.dart';

@Database(version: 1, entities: [Palpite])
abstract class AppDatabase extends FloorDatabase {
  PalpiteDao get personDao;
}
