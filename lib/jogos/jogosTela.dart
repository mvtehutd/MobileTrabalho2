import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabalho2/barraSuperior.dart';
import 'package:tabalho2/data/listaJogos.dart';
import 'package:tabalho2/jogo/jogoTela.dart';
import 'jogosViewModel.dart';
import 'package:jovial_svg/jovial_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class JogosTela extends StatefulWidget {
  @override
  _JogosTelaState createState() => _JogosTelaState();
}

class _JogosTelaState extends State<JogosTela> {
  @override
  void initState() {
    super.initState();
    // Obtenha a instância do ViewModel do Provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<JogosViewModel>(context, listen: false)
          .verificarJogosAoVivo();
    });
  }

  @override
  Widget build(BuildContext context) {
    JogosViewModel viewModel =
        Provider.of<JogosViewModel>(context, listen: true);
    return Scaffold(
      appBar: BarraSuperior(
          titulo: AppLocalizations.of(context)!.jogos_dia,
          onRefresh: () => {viewModel.recarregar()}),
      body: Consumer<JogosViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.carregando) {
            return const Center(child: CircularProgressIndicator());
          } else if (viewModel.jogos.isEmpty) {
            return Center(
                child: Text(AppLocalizations.of(context)!.nenhum_jogo));
          } else {
            return CampeonatosLista(campeonatos: viewModel.jogos);
          }
        },
      ),
    );
  }
}

class CampeonatosLista extends StatelessWidget {
  final List<CampeonatoJogos> campeonatos;

  const CampeonatosLista({
    super.key,
    required this.campeonatos,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: campeonatos.length,
      itemBuilder: (context, index) {
        return Padding(
            padding: const EdgeInsets.only(
                top: 10, left: 10, right: 10), // Espaçamento nas laterais
            child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFCCCCCC), // Cor de fundo da tabela
                  borderRadius:
                      BorderRadius.circular(10.0), // Bordas arredondadas
                ),
                child: CampeonatoItem(
                  campeonato: campeonatos[index],
                )));
      },
    );
  }
}

class CampeonatoItem extends StatelessWidget {
  final CampeonatoJogos campeonato;

  const CampeonatoItem({
    super.key,
    required this.campeonato,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 5),
              // Image.network(
              //   campeonato.urlLogo,
              //   width: 40,
              //   height: 40,
              // ),
              // const SizedBox(width: 10),
              Text(
                campeonato.campeonato,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const Divider(thickness: 1, color: Colors.grey),
          Column(
            children:
                campeonato.jogos.map((jogo) => JogoItem(jogo: jogo)).toList(),
          ),
        ],
      ),
    );
  }
}

class JogoItem extends StatelessWidget {
  final JogoInicio jogo;

  const JogoItem({
    super.key,
    required this.jogo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => JogoTela(id: jogo.id)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text for tempo with fixed width
            SizedBox(
              width: 40, // Fixed width for tempo
              child: Text(
                _formatTempo(jogo.tempo),
                style: TextStyle(
                  fontSize: 12,
                  color: jogo.golsMandante != null && jogo.tempo != "FIM"
                      ? Colors.red
                      : Colors.grey[800],
                  fontWeight: FontWeight.bold,
                ),
                textAlign:
                    TextAlign.center, // Center text within the fixed width
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                jogo.mandante,
                textAlign: TextAlign.end,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 25,
              height: 25,
              child: ScalableImageWidget.fromSISource(
                si: ScalableImageSource.fromSvgHttpUrl(
                    Uri.parse(jogo.urlLogoMandante)),
              ),
            ),
            const SizedBox(width: 4),
            // Text for score with fixed width
            SizedBox(
              width: 45, // Fixed width for score
              child: Text(
                _formatScore(jogo.golsMandante, jogo.golsVisitante),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: jogo.golsMandante != null && jogo.tempo != "FIM"
                      ? Colors.red
                      : Colors.grey[800],
                ),
                textAlign:
                    TextAlign.center, // Center text within the fixed width
              ),
            ),
            const SizedBox(width: 4),
            SizedBox(
              width: 25,
              height: 25,
              child: ScalableImageWidget.fromSISource(
                si: ScalableImageSource.fromSvgHttpUrl(
                    Uri.parse(jogo.urlLogoVisitante)),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                jogo.visitante,
                textAlign: TextAlign.start,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTempo(String tempo) {
    final regex = RegExp(r'^[0-9+]+$');
    return regex.hasMatch(tempo) ? "$tempo'" : tempo;
  }

  String _formatScore(int? golsMandante, int? golsVisitante) {
    if (golsMandante != null && golsVisitante != null) {
      return "$golsMandante x $golsVisitante";
    } else {
      return "x";
    }
  }
}
