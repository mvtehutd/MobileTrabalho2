import 'package:flutter/cupertino.dart';
import 'package:tabalho2/data/listaJogos.dart';
import '../servico/jogosRepository.dart';
import 'dart:async';

class JogosViewModel extends ChangeNotifier {
  final JogosRepository repository;
  List<CampeonatoJogos> _jogos = [];
  bool _carregando = true;
  bool _timerAtivo = false;

  bool get carregando => _carregando;
  List<CampeonatoJogos> get jogos => _jogos;

  JogosViewModel({required this.repository});

  Future<void> verificarJogosAoVivo() async {
    _carregando = true;
    if (!_timerAtivo) {
      _timerAtivo = true;
      var streamsJogos = repository.obterJogosAoVivo();
      await for (var jogosResposta in streamsJogos) {
        _jogos = jogosResposta;
        _carregando = false;
        notifyListeners();
        print("OK");
      }
    }
  }

  Future<void> recarregar() async {
    _carregando = true;
    try {
      _jogos = await repository.obterJogos();
      print("RECARREGA");
      _carregando = false;
      notifyListeners();
    } catch (e) {}
  }
}
