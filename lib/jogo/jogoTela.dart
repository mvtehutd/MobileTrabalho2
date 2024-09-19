import 'package:flutter/material.dart';
import 'package:jovial_svg/jovial_svg.dart';
import 'package:provider/provider.dart';
import '../data/jogo.dart';
import '../persistencia/palpite.dart';
import 'jogoViewModel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class JogoTela extends StatefulWidget {
  final int id;

  JogoTela({required this.id});

  @override
  _JogoTelaState createState() => _JogoTelaState();
}

class _JogoTelaState extends State<JogoTela> {
  late final JogoViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<JogoViewModel>(context, listen: false);
    viewModel.verificarJogoAoVivo(widget.id);
  }

  @override
  void dispose() {
    viewModel.pararVerificacao();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<JogoViewModel>(context, listen: true);
    final jogo = viewModel.jogo;
    final palpite = viewModel.palpite;

    if (jogo == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          leading: const BackButton(),
          title: Align(
              alignment: Alignment.center,
              child: Text(AppLocalizations.of(context)!.jogo,
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
              onPressed: () => viewModel.recarregar(widget.id),
            ),
          ],
          toolbarHeight: 120,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment:
              CrossAxisAlignment.center, // Centraliza horizontalmente
          children: [
            // Primeira linha - Campeonato e fase do jogo
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centraliza a linha toda
              children: [
                Text(
                  '${jogo.campeonato} - ${jogo.fase}',
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center, // Centraliza o texto
                ),
              ],
            ),
            const SizedBox(height: 10), // Espaçamento entre as linhas

            // Segunda linha - Informações do jogo
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceEvenly, // Distribui os elementos de forma equilibrada
              children: [
                // Nome e logo do time mandante
                Row(
                  children: [
                    Text(jogo.mandante, style: const TextStyle(fontSize: 14)),
                    const SizedBox(
                        width: 7), // Espaçamento entre o nome e o logo
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: ScalableImageWidget.fromSISource(
                        si: ScalableImageSource.fromSvgHttpUrl(
                            Uri.parse(jogo.urlLogoMandante)),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 5),
                // Coluna com tempo e placar
                Column(
                  children: [
                    Text(
                      _formatTempo(jogo.tempo),
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.black),
                    ),
                    if (jogo.golsMandante != null)
                      Text(
                        '${jogo.golsMandante} x ${jogo.golsVisitante}',
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: Colors.black),
                      ),
                  ],
                ),
                const SizedBox(width: 5),
                // Logo e nome do time visitante
                Row(
                  children: [
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: ScalableImageWidget.fromSISource(
                        si: ScalableImageSource.fromSvgHttpUrl(
                            Uri.parse(jogo.urlLogoVisitante)),
                      ),
                    ),
                    const SizedBox(
                        width: 8), // Espaçamento entre o logo e o nome
                    Text(jogo.visitante, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.blue,
        leading: const BackButton(),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.black,
            ),
            onPressed: () => viewModel.recarregar(widget.id),
          ),
        ],
        toolbarHeight:
            120, // Aumenta a altura da AppBar para acomodar duas linhas
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          if (jogo.lances.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: const Color(0xFFCCCCCC),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: jogo.lances
                    .map<Widget>((lance) => LanceItem(lance))
                    .toList(),
              ),
            ),
          ],
          const SizedBox(height: 20),
          Container(
            height: 250,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: const Color(0xFFCCCCCC),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              children: [
                const SizedBox(height: 5),
                Text(
                  AppLocalizations.of(context)!.palpite,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                palpite != null
                    ? WidgetPalpite(palpite: palpite, jogo: jogo)
                    : BotoesPalpite(
                        viewModel: viewModel,
                        id: jogo.id,
                        mandante: jogo.mandante,
                        visitante: jogo.visitante),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _formatTempo(String tempo) {
  final regex = RegExp(r'^[0-9+]+$');
  return regex.hasMatch(tempo) ? "$tempo'" : tempo;
}

class LanceItem extends StatelessWidget {
  final Lance lance;

  const LanceItem(this.lance);

  @override
  Widget build(BuildContext context) {
    final alignment =
        lance.isHomeTeam ? MainAxisAlignment.start : MainAxisAlignment.end;
    final icone = getIconeForLance(lance.tipo);

    return Padding(
        padding: const EdgeInsets.only(left: 5, top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: alignment,
          children: [
            if (lance.isHomeTeam) ...[
              SizedBox(
                  width: 45,
                  child: Text(
                    '${lance.minuto}\'',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )),
              const SizedBox(width: 8),
              Image.asset(icone, width: 24, height: 24),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: lance.isHomeTeam
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  Text(
                    lance.nomeJogador1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (lance.nomeJogador2 != null)
                    Text(
                      lance.nomeJogador2!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            if (!lance.isHomeTeam) ...[
              const SizedBox(width: 8),
              Image.asset(icone, width: 24, height: 24),
              const SizedBox(width: 8),
              SizedBox(
                  width: 45,
                  child: Text(
                    '${lance.minuto}\'',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  )),
            ],
          ],
        ));
  }

  String getIconeForLance(String tipo) {
    switch (tipo) {
      case 'Gol':
        return 'assets/lances/ic_gol.png';
      case 'Gol Pênalti':
        return 'assets/lances/ic_gol_penalti.png';
      case 'Gol Contra':
        return 'assets/lances/ic_gol_contra.png';
      case 'Cartão Amarelo':
        return 'assets/lances/ic_cartao_amarelo.png';
      case 'Segundo Amarelo':
        return 'assets/lances/ic_segundo_amarelo.png';
      case 'Cartão Vermelho':
        return 'assets/lances/ic_cartao_vermelho.png';
      case 'Substituição':
        return 'assets/lances/ic_substituicao.png';
      case 'Pênalti Perdido':
        return 'assets/lances/ic_penalti_perdido.png';
      default:
        return 'assets/lances/ic_var.png';
    }
  }
}

class WidgetPalpite extends StatelessWidget {
  final Palpite palpite;
  final Jogo jogo;

  const WidgetPalpite({required this.palpite, required this.jogo});

  @override
  Widget build(BuildContext context) {
    final logo = palpite.time == jogo.mandante
        ? jogo.urlLogoMandante
        : jogo.urlLogoVisitante;
    final viewModel = Provider.of<JogoViewModel>(context);

    return Column(
      children: [
        const SizedBox(height: 10),
        Text(AppLocalizations.of(context)!.votou_em,
            textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (palpite.time != 'Empate') ...[
              SizedBox(
                width: 40,
                height: 40,
                child: ScalableImageWidget.fromSISource(
                  si: ScalableImageSource.fromSvgHttpUrl(Uri.parse(logo)),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Text(
                palpite.time != 'Empate'
                    ? palpite.time
                    : AppLocalizations.of(context)!.empate,
                style: const TextStyle(fontSize: 25)),
          ],
        ),
        const SizedBox(height: 25),
        SizedBox(
          width: 200, // Largura fixa
          height: 50, // Altura fixa
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[600],
                  foregroundColor: Colors.black),
              onPressed: () => viewModel.removerPalpite(jogo.id),
              child: Text(AppLocalizations.of(context)!.excluir_palpite,
                  style: const TextStyle(fontSize: 16))),
        ),
      ],
    );
  }
}

class BotoesPalpite extends StatelessWidget {
  final JogoViewModel viewModel;
  final int id;
  final String mandante;
  final String visitante;

  const BotoesPalpite({
    required this.viewModel,
    required this.id,
    required this.mandante,
    required this.visitante,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
            width: 200, // Largura fixa
            height: 50, // Altura fixa
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[600],
                  foregroundColor: Colors.black),
              onPressed: () => viewModel.inserirPalpite(id, mandante),
              child: Text(mandante,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            )),
        const SizedBox(height: 10),
        SizedBox(
            width: 200, // Largura fixa
            height: 50, // Altura fixa
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[600],
                  foregroundColor: Colors.black),
              onPressed: () => viewModel.inserirPalpite(id, 'Empate'),
              child: Text(
                AppLocalizations.of(context)!.empate,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )),
        const SizedBox(height: 10),
        SizedBox(
            width: 200, // Largura fixa
            height: 50, // Altura fixa
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[600],
                  foregroundColor: Colors.black),
              onPressed: () => viewModel.inserirPalpite(id, visitante),
              child: Text(visitante,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            )),
        const SizedBox(height: 10),
      ],
    );
  }
}
