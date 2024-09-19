class CampeonatoJogos {
  final String campeonato;
  final List<JogoInicio> jogos;

  CampeonatoJogos({required this.campeonato, required this.jogos});

  factory CampeonatoJogos.fromJson(Map<String, dynamic> json) {
    return CampeonatoJogos(
      campeonato: json['campeonato'],
      jogos: List<JogoInicio>.from(
          json['jogos'].map((jogo) => JogoInicio.fromJson(jogo))),
    );
  }
}

class JogoInicio {
  final int? golsMandante;
  final int? golsVisitante;
  final int id;
  final String mandante;
  final String tempo;
  final String urlLogoMandante;
  final String urlLogoVisitante;
  final String visitante;

  JogoInicio({
    this.golsMandante,
    this.golsVisitante,
    required this.id,
    required this.mandante,
    required this.tempo,
    required this.urlLogoMandante,
    required this.urlLogoVisitante,
    required this.visitante,
  });

  factory JogoInicio.fromJson(Map<String, dynamic> json) {
    return JogoInicio(
      golsMandante: json['golsMandante'],
      golsVisitante: json['golsVisitante'],
      id: json['id'],
      mandante: json['mandante'],
      tempo: json['tempo'],
      urlLogoMandante: json['url_logo_mandante'],
      urlLogoVisitante: json['url_logo_visitante'],
      visitante: json['visitante'],
    );
  }
}
