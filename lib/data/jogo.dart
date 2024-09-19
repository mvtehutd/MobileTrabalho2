class Jogo {
  final String campeonato;
  final String fase;
  final int? golsMandante;
  final int? golsVisitante;
  final int id;
  final List<Lance> lances;
  final String mandante;
  final String siglaMandante;
  final String siglaVisitante;
  final String tempo;
  final String urlLogoMandante;
  final String urlLogoVisitante;
  final String visitante;

  Jogo({
    required this.campeonato,
    required this.fase,
    required this.golsMandante,
    required this.golsVisitante,
    required this.id,
    required this.lances,
    required this.mandante,
    required this.siglaMandante,
    required this.siglaVisitante,
    required this.tempo,
    required this.urlLogoMandante,
    required this.urlLogoVisitante,
    required this.visitante,
  });

  factory Jogo.fromJson(Map<String, dynamic> json) {
    return Jogo(
      campeonato: json['campeonato'],
      fase: json['fase'],
      golsMandante: json['golsMandante'],
      golsVisitante: json['golsVisitante'],
      id: json['id'],
      lances: (json['lances'] as List).map((x) => Lance.fromJson(x)).toList(),
      mandante: json['mandante'],
      siglaMandante: json['siglaMandante'],
      siglaVisitante: json['siglaVisitante'],
      tempo: json['tempo'],
      urlLogoMandante: json['url_logo_mandante'],
      urlLogoVisitante: json['url_logo_visitante'],
      visitante: json['visitante'],
    );
  }
}

class Lance {
  final String tipo;
  final String minuto;
  final String numeroJogador1;
  final String nomeJogador1;
  final String? numeroJogador2; // Campos opcionais
  final String? nomeJogador2; // Campos opcionais
  final bool isHomeTeam;

  Lance({
    required this.tipo,
    required this.minuto,
    required this.numeroJogador1,
    required this.nomeJogador1,
    this.numeroJogador2, // Campos opcionais podem ser nulos
    this.nomeJogador2, // Campos opcionais podem ser nulos
    required this.isHomeTeam,
  });

  factory Lance.fromJson(Map<String, dynamic> json) {
    return Lance(
      tipo: json['indicador'],
      minuto: json['minuto'],
      numeroJogador1: json['numero'],
      nomeJogador1: json['nome'],
      numeroJogador2: json['numeroSai'] ?? null, // Checagem de campo opcional
      nomeJogador2: json['nomeSai'] ?? null, // Checagem de campo opcional
      isHomeTeam: json['mandante'],
    );
  }
}
