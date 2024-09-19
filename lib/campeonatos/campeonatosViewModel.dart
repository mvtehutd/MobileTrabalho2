import 'package:flutter/material.dart';
import 'package:tabalho2/data/listaCampeonatos.dart';
import 'package:tabalho2/servico/jogosRepository.dart';

class CampeonatosViewModel extends ChangeNotifier {
  final JogosRepository repository;
  List<ItemListaCampeonatos> _campeonatos = [];
  bool _carregando = false;
  String? _mensagemErro;

  CampeonatosViewModel({required this.repository});

  List<ItemListaCampeonatos> get campeonatos => _campeonatos;
  bool get carregando => _carregando;
  String? get mensagemErro => _mensagemErro;

  Future<void> obterCampeonatos() async {
    _carregando = true;
    notifyListeners();

    try {
      _campeonatos = await repository.obterCampeonatos();
    } catch (e) {
      _mensagemErro = 'Erro de conexão: $e';
    }

    _carregando = false;
    notifyListeners();
  }
}
