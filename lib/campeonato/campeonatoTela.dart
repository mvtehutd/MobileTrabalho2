import 'package:flutter/material.dart';
import 'package:jovial_svg/jovial_svg.dart'; // ou outra biblioteca de SVG
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'campeonatoViewModel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CampeonatoTela extends StatefulWidget {
  final int campeonatoId;

  const CampeonatoTela({super.key, required this.campeonatoId});

  @override
  _CampeonatoTelaState createState() => _CampeonatoTelaState();
}

class _CampeonatoTelaState extends State<CampeonatoTela> {
  late CampeonatoViewModel viewModel;

  @override
  void initState() {
    super.initState();
    // Chama o método para buscar os campeonatos quando a página é inicializada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CampeonatoViewModel>(context, listen: false)
          .obterCampeonato(widget.campeonatoId);
    });
  }

  @override
  Widget build(BuildContext context) {
    CampeonatoViewModel viewModel = Provider.of<CampeonatoViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Cor de fundo da AppBar
        elevation: 4.0,
        title: Align(
            alignment: Alignment.center,
            child: Text(AppLocalizations.of(context)!.campeonato,
                textAlign:
                    TextAlign.center, // Centraliza o texto dentro do Expanded
                style: const TextStyle(
                  fontSize: 20, // Tamanho do texto
                  fontWeight: FontWeight.bold, // Peso da fonte
                ))),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {
                viewModel.obterCampeonato(widget.campeonatoId);
              });
            },
          ),
        ],
        toolbarHeight: 60,
      ),
      body: Consumer<CampeonatoViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.carregando) {
            return const Center(child: CircularProgressIndicator());
          } else if (viewModel.mensagemErro != null) {
            return Center(child: Text(viewModel.mensagemErro!));
          } else if (viewModel.campeonato == null) {
            return Center(
                child: Text(AppLocalizations.of(context)!.nenhum_campeonato));
          } else {
            return SingleChildScrollView(
              // Rola verticalmente toda a tela
              child: Column(
                children: [
                  // Cabeçalho
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, top: 12, bottom: 5),
                    child: Row(
                      children: [
                        Image.network(
                          viewModel.campeonato!.urlLogo,
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          viewModel.campeonato!.campeonato,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[900],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Tabela de Classificação com fundo colorido e sem borda
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0), // Espaçamento nas laterais
                    child: SingleChildScrollView(
                      scrollDirection:
                          Axis.horizontal, // Rola horizontalmente a tabela
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              const Color(0xFFCCCCCC), // Cor de fundo da tabela
                          borderRadius: BorderRadius.circular(
                              10.0), // Bordas arredondadas
                        ),
                        child: DataTable(
                          horizontalMargin: 10,
                          dataRowMinHeight: 20,
                          dataRowMaxHeight:
                              30, // Altura das linhas de dados (ajuste conforme necessário)
                          headingRowHeight: 30, // Altura da linha de cabeçalho
                          columnSpacing:
                              15, // Reduz o espaçamento entre colunas
                          dividerThickness:
                              0, // Remove os traços entre as linhas
                          columns: [
                            DataColumn(label: Text('')),
                            DataColumn(
                                label:
                                    Text(AppLocalizations.of(context)!.time)),
                            DataColumn(
                                label:
                                    Text(AppLocalizations.of(context)!.pontos),
                                headingRowAlignment: MainAxisAlignment.center),
                            DataColumn(
                                label: Text(
                                    AppLocalizations.of(context)!.jogosTabela),
                                headingRowAlignment: MainAxisAlignment.center),
                            DataColumn(
                                label: Text(
                                    AppLocalizations.of(context)!.vitorias),
                                headingRowAlignment: MainAxisAlignment.center),
                            DataColumn(
                                label:
                                    Text(AppLocalizations.of(context)!.empates),
                                headingRowAlignment: MainAxisAlignment.center),
                            DataColumn(
                                label: Text(
                                    AppLocalizations.of(context)!.derrotas),
                                headingRowAlignment: MainAxisAlignment.center),
                            DataColumn(
                                label: Text(
                                    AppLocalizations.of(context)!.saldo_gols),
                                headingRowAlignment: MainAxisAlignment.center),
                            DataColumn(
                                label: Text(
                                    AppLocalizations.of(context)!.gols_pro),
                                headingRowAlignment: MainAxisAlignment.center),
                            DataColumn(
                                label: Text(
                                    AppLocalizations.of(context)!.gols_contra),
                                headingRowAlignment: MainAxisAlignment.center),
                            DataColumn(
                                label: Text(AppLocalizations.of(context)!
                                    .aproveitamento),
                                headingRowAlignment: MainAxisAlignment.center),
                          ],
                          rows: viewModel.campeonato!.classificacao[0].linhas
                              .map((linha) {
                            final coresLegenda =
                                obterCoresLegenda(linha.idLegenda, viewModel);
                            return DataRow(
                              cells: [
                                DataCell(circleWithText(
                                    linha.posicao.toString(),
                                    coresLegenda.item1,
                                    coresLegenda.item2)),
                                DataCell(
                                  Container(
                                    constraints: const BoxConstraints(
                                      minWidth: 140,
                                      maxWidth:
                                          140, // Define a largura máxima da coluna
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 25,
                                          height: 25,
                                          child:
                                              ScalableImageWidget.fromSISource(
                                            si: ScalableImageSource
                                                .fromSvgHttpUrl(
                                                    Uri.parse(linha.logo)),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            linha.time,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                DataCell(Center(
                                    child: Text(linha.pontos.toString()))),
                                DataCell(Center(
                                    child: Text(linha.jogos.toString()))),
                                DataCell(Center(
                                    child: Text(linha.vitorias.toString()))),
                                DataCell(Center(
                                    child: Text(linha.empates.toString()))),
                                DataCell(Center(
                                    child: Text(linha.derrotas.toString()))),
                                DataCell(Center(
                                    child: Text(linha.saldoGols.toString()))),
                                DataCell(Center(
                                    child: Text(linha.golsPro.toString()))),
                                DataCell(Center(
                                    child: Text(linha.golsContra.toString()))),
                                DataCell(Center(
                                    child: Text("${linha.aproveitamento}%"))),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  // Legenda
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: viewModel.campeonato!.legenda
                          .map((legenda) => Row(
                                children: [
                                  const SizedBox(height: 22),
                                  circleWithColor(
                                      Color(int.parse(legenda.corFundo))),
                                  const SizedBox(width: 8),
                                  Text(
                                    legenda.nome,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[900],
                                    ),
                                  ),
                                ],
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  // Função para gerar a bolinha com a posição do time
  Widget circleWithText(String texto, Color corFundo, Color corTexto) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: corFundo,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          texto,
          textAlign: TextAlign.center,
          style: TextStyle(color: corTexto, fontSize: 12),
        ),
      ),
    );
  }

  // Função para gerar a bolinha colorida na legenda
  Widget circleWithColor(Color color) {
    return Container(
      width: 17,
      height: 17,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  // Função para obter as cores da legenda baseada no ID da legenda
  Tuple2<Color, Color> obterCoresLegenda(
      int? idLegenda, CampeonatoViewModel viewModel) {
    if (idLegenda == null) {
      return const Tuple2(Color(0xFFCCCCCC), Color(0xFF000000)); // Cinza
    } else {
      final legenda = viewModel.campeonato!.legenda
          .firstWhere((item) => item.id == idLegenda);
      return Tuple2(Color(int.parse(legenda.corFundo)),
          Color(int.parse(legenda.corTexto)));
    }
  }
}
