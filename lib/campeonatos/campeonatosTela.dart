import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../barraSuperior.dart';
import '../campeonato/campeonatoTela.dart';
import 'campeonatosViewModel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CampeonatosTela extends StatefulWidget {
  @override
  _CampeonatosTelaState createState() => _CampeonatosTelaState();
}

class _CampeonatosTelaState extends State<CampeonatosTela> {
  @override
  void initState() {
    super.initState();
    // Chama o método para buscar os campeonatos quando a página é inicializada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CampeonatosViewModel>(context, listen: false)
          .obterCampeonatos();
    });
  }

  @override
  Widget build(BuildContext context) {
    CampeonatosViewModel viewModel = Provider.of<CampeonatosViewModel>(context);

    return Scaffold(
      appBar: BarraSuperior(
          titulo: AppLocalizations.of(context)!.campeonatos,
          onRefresh: () => {viewModel.obterCampeonatos()}),
      body: Consumer<CampeonatosViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.carregando) {
            return const Center(child: CircularProgressIndicator());
          } else if (viewModel.mensagemErro != null) {
            return Center(
                child: Text(
                    '${AppLocalizations.of(context)!.erro}: ${viewModel.mensagemErro}'));
          } else if (viewModel.campeonatos.isEmpty) {
            return Center(
                child: Text(AppLocalizations.of(context)!.nenhum_campeonato));
          } else {
            return ListView.builder(
              itemCount: viewModel.campeonatos.length,
              itemBuilder: (context, index) {
                final campeonato = viewModel.campeonatos[index];
                return Card(
                    color: const Color(0xFFCCCCCC),
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Image.network(
                        campeonato.urlLogo,
                        width: 40,
                        height: 40,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error),
                      ),
                      title: Text(campeonato.campeonato,
                          style: const TextStyle(
                            fontSize: 20, // Tamanho do texto
                            fontWeight: FontWeight.bold, // Peso da fonte
                          )),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CampeonatoTela(campeonatoId: campeonato.id)),
                        );
                      },
                    ));
              },
            );
          }
        },
      ),
    );
  }
}
