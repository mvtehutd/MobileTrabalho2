import 'package:flutter/material.dart';
import 'package:tabalho2/barraInferior.dart';
import 'package:tabalho2/campeonatos/campeonatosTela.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tabalho2/jogos/jogosTela.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _selectedIndex == 0 ? JogosTela() : CampeonatosTela(),
        bottomNavigationBar: BarraInferior(
            selectedIndex: _selectedIndex, onItemTapped: _onItemTapped));
  }
}
