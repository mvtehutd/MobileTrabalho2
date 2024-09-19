import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BarraSuperior extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final VoidCallback? onRefresh;

  const BarraSuperior({required this.titulo, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue, // Cor de fundo da AppBar
      elevation: 4.0, // Sombra abaixo da AppBar
      title: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Espaço entre os elementos
        children: [
          // Espaço vazio à esquerda para centralizar o título
          if (onRefresh != null) const SizedBox(width: 48),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                titulo,
                textAlign:
                    TextAlign.center, // Centraliza o texto dentro do Expanded
                style: const TextStyle(
                  fontSize: 20, // Tamanho do texto
                  fontWeight: FontWeight.bold, // Peso da fonte
                ),
              ),
            ),
          ),
          // Botão de refresh à direita
          if (onRefresh != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: onRefresh,
              tooltip: AppLocalizations.of(context)!.recarregar,
            ),
        ],
      ),
      toolbarHeight: 60, // Altura personalizada da AppBar
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(60); // Tamanho personalizado da AppBar
}
