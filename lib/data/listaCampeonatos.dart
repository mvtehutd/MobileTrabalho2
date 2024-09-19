class ItemListaCampeonatos {
  final String campeonato;
  final int id;
  final String urlLogo;

  ItemListaCampeonatos({
    required this.campeonato,
    required this.id,
    required this.urlLogo,
  });

  // Factory method to create a `Campeonato` from JSON
  factory ItemListaCampeonatos.fromJson(Map<String, dynamic> json) {
    return ItemListaCampeonatos(
      campeonato: json['campeonato'],
      id: json['id'],
      urlLogo: json['url_logo'],
    );
  }
}
