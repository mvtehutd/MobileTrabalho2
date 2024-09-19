import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabalho2/campeonatos/campeonatosViewModel.dart';
import 'package:tabalho2/jogos/jogosViewModel.dart';
import 'package:tabalho2/persistencia/palpiteRepository.dart';
import 'package:tabalho2/servico/jogosRepository.dart';
import 'app.dart';
import 'campeonato/campeonatoViewModel.dart';
import 'jogo/jogoViewModel.dart';

void main() async {
  // Required for initialization tasks called before runApp()
  WidgetsFlutterBinding.ensureInitialized();

  final repository = JogosRepository();

  final persistencia = PalpiteRepository();
  await persistencia.initialize();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (_) => JogosViewModel(repository: repository)),
      ChangeNotifierProvider(
          create: (_) => JogoViewModel(
                repository: repository,
                palpiteRepository: persistencia,
              )),
      ChangeNotifierProvider(
          create: (_) => CampeonatosViewModel(repository: repository)),
      ChangeNotifierProvider(
          create: (_) => CampeonatoViewModel(repository: repository))
    ],
    child: MyApp(),
  ));
}
