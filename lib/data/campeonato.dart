// Classe para o Campeonato
class Campeonato {
  final int id;
  final String campeonato;
  final String urlLogo;
  final List<Classificacao> classificacao;
  final List<Legenda> legenda;

  Campeonato({
    required this.id,
    required this.campeonato,
    required this.urlLogo,
    required this.classificacao,
    required this.legenda,
  });

  factory Campeonato.fromJson(Map<String, dynamic> json) {
    var classificacaoJson = json['classificacao'] as List;
    List<Classificacao> classificacaoList =
        classificacaoJson.map((item) => Classificacao.fromJson(item)).toList();
    var legendaJson = json['legenda'] as List;
    List<Legenda> legendaList =
        legendaJson.map((item) => Legenda.fromJson(item)).toList();
    return Campeonato(
      id: json['id'],
      campeonato: json['campeonato'],
      urlLogo: json['url_logo'],
      classificacao: classificacaoList,
      legenda: legendaList,
    );
  }
}

// Classe para a Classificacao
class Classificacao {
  final String tabela;
  final List<LinhaClassificacao> linhas;

  Classificacao({required this.tabela, required this.linhas});

  factory Classificacao.fromJson(Map<String, dynamic> json) {
    var linhasJson = json['linhas'] as List;
    List<LinhaClassificacao> linhasList =
        linhasJson.map((linha) => LinhaClassificacao.fromJson(linha)).toList();

    return Classificacao(
      tabela: json['tabela'],
      linhas: linhasList,
    );
  }
}

// Classe para a Linha da Classificação
class LinhaClassificacao {
  final int aproveitamento;
  final int derrotas;
  final int empates;
  final int golsContra;
  final int golsPro;
  final int? idLegenda;
  final int jogos;
  final String logo;
  final int pontos;
  final int posicao;
  final int saldoGols;
  final String sigla;
  final String time;
  final int vitorias;

  LinhaClassificacao({
    required this.aproveitamento,
    required this.derrotas,
    required this.empates,
    required this.golsContra,
    required this.golsPro,
    this.idLegenda,
    required this.jogos,
    required this.logo,
    required this.pontos,
    required this.posicao,
    required this.saldoGols,
    required this.sigla,
    required this.time,
    required this.vitorias,
  });

  factory LinhaClassificacao.fromJson(Map<String, dynamic> json) {
    return LinhaClassificacao(
      aproveitamento: json['aproveitamento'],
      derrotas: json['derrotas'],
      empates: json['empates'],
      golsContra: json['golsContra'],
      golsPro: json['golsPro'],
      idLegenda: json['idLegenda'],
      jogos: json['jogos'],
      logo: json['logo'],
      pontos: json['pontos'],
      posicao: json['posicao'],
      saldoGols: json['saldoGols'],
      sigla: json['sigla'],
      time: json['time'],
      vitorias: json['vitorias'],
    );
  }
}

// Classe para a Legenda
class Legenda {
  final int id;
  final String nome;
  final String corFundo;
  final String corTexto;

  Legenda(
      {required this.id,
      required this.nome,
      required this.corFundo,
      required this.corTexto});

  factory Legenda.fromJson(Map<String, dynamic> json) {
    return Legenda(
      id: int.parse(
          json['id'].toString()), // Convertendo String para int se necessário
      nome: json['nome'],
      corFundo: json['corFundo'],
      corTexto: json['corTexto'],
    );
  }
}
