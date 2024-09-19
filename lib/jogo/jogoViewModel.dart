import 'dart:async';
import 'package:tabalho2/persistencia/palpite.dart';
import 'package:tabalho2/persistencia/palpiteRepository.dart';

import '../data/jogo.dart';
import '../servico/jogosRepository.dart';
import 'package:flutter/cupertino.dart';

class JogoViewModel extends ChangeNotifier {
  final JogosRepository repository;
  final PalpiteRepository palpiteRepository;
  StreamSubscription<Jogo>? _jogoStream;
  Jogo? _jogo;
  Palpite? _palpite;
  bool _carregando = false;
  bool _timerAtivo = false;

  get carregando => _carregando;
  get jogo => _jogo;
  get palpite => _palpite;

  JogoViewModel({required this.repository, required this.palpiteRepository});

  void verificarJogoAoVivo(int id) {
    if (!_timerAtivo) {
      _timerAtivo = true;
      var stream = repository.obterJogoAoVivo(id);

      _jogoStream = stream.listen((jogo) {
        _jogo = jogo;
        print("VERIFICA JOGO");
        notifyListeners();
      });
    }
  }

  Future<void> recarregar(int id) async {
    _carregando = true;
    try {
      _jogo = await repository.obterJogo(id);
      print("RECARREGA JOGO");
      _carregando = false;
      notifyListeners();
    } catch (e) {}
  }

  void pararVerificacao() {
    _timerAtivo = false;
    _jogoStream?.cancel();
    _jogo = null;
    repository.pararJogoAoVivo();
  }

  obterPalpite(int id) async {
    var streamPalpite = palpiteRepository.obterPalpite(id);
    await for (var palpiteResposta in streamPalpite) {
      _palpite = palpiteResposta;
      notifyListeners();
    }
  }

  inserirPalpite(int id, String time) async {
    palpiteRepository.inserirPalpite(Palpite(id, time));
    obterPalpite(id);
  }

  removerPalpite(int id) async {
    palpiteRepository.removerPalpite(id);
    obterPalpite(id);
  }
}
