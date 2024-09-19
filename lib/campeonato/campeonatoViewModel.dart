import 'package:flutter/material.dart';
import 'package:tabalho2/data/campeonato.dart';
import 'package:tabalho2/servico/jogosRepository.dart';

class CampeonatoViewModel extends ChangeNotifier {
  final JogosRepository repository;
  Campeonato? _campeonato = null;
  bool _carregando = false;
  String? _mensagemErro;

  CampeonatoViewModel({required this.repository});

  Campeonato? get campeonato => _campeonato;
  bool get carregando => _carregando;
  String? get mensagemErro => _mensagemErro;

  Future<void> obterCampeonato(int id) async {
    _carregando = true;
    notifyListeners();

    try {
      _campeonato = await repository.obterCampeonato(id);
    } catch (e) {
      _mensagemErro = 'Erro de conexão: $e';
    }

    _carregando = false;
    notifyListeners();
  }
}
