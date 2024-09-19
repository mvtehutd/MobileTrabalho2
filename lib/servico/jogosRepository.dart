import 'package:dio/dio.dart';
import 'package:tabalho2/data/campeonato.dart';
import 'package:tabalho2/data/jogo.dart';
import 'package:tabalho2/data/listaJogos.dart';

import '../data/listaCampeonatos.dart';

class JogosRepository {
  final _dio = Dio(BaseOptions(baseUrl: "https://jogos.squareweb.app/api/"));
  bool _jogoAoVivo = false;

  Stream<List<CampeonatoJogos>> obterJogosAoVivo() async* {
    while (true) {
      try {
        var jogos = await obterJogos();
        yield jogos;
        await Future.delayed(Duration(seconds: 10));
      } catch (e) {
        print(e);
      } finally {}
    }
  }

  Future<List<CampeonatoJogos>> obterJogos() async {
    final response = await _dio.get('/jogos');
    if (response.statusCode == 200) {
      var jogosFromJson = response.data as List;
      return jogosFromJson
          .map((jogosJson) => CampeonatoJogos.fromJson(jogosJson))
          .toList();
    } else {
      throw Exception('Exception');
    }
  }

  Stream<Jogo> obterJogoAoVivo(int id) async* {
    _jogoAoVivo = true;
    while (_jogoAoVivo) {
      try {
        var board = await obterJogo(id);
        yield board;
      } catch (e) {
        print('obterJogo $id Encontrado erro Ao Vivo: $e');
      } finally {
        await Future.delayed(Duration(seconds: 10));
      }
    }
  }

  Future<Jogo> obterJogo(int id) async {
    try {
      final response = await _dio.get('/jogos/$id');
      if (response.statusCode == 200) {
        return Jogo.fromJson(response.data);
      } else {
        throw Exception('Falha ao Carregar Jogo');
      }
    } catch (e) {
      throw Exception('Erro ao Obter Jogo: $e');
    }
  }

  // Stop active stream of a board
  void pararJogoAoVivo() {
    _jogoAoVivo = false;
  }

  Future<List<ItemListaCampeonatos>> obterCampeonatos() async {
    final response = await _dio.get(
      '/campeonatos',
    );
    if (response.statusCode == 200) {
      List<dynamic> data = response.data;
      return data.map((json) => ItemListaCampeonatos.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar os dados dos campeonatos');
    }
  }

  Future<Campeonato> obterCampeonato(int id) async {
    final response = await _dio.get(
      '/campeonatos/$id',
    );
    if (response.statusCode == 200) {
      dynamic data = response.data;
      return Campeonato.fromJson(data);
    } else {
      throw Exception('Falha ao carregar os dados do Campeonato');
    }
  }
}
