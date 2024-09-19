import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BarraInferior extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  BarraInferior({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: _buildIconWithElipse(
              0, Icons.sports_soccer, AppLocalizations.of(context)!.jogos),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildIconWithElipse(
              1, Icons.emoji_events, AppLocalizations.of(context)!.campeonatos),
          label: '',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      backgroundColor: Colors.blue,
      // Cor de fundo da barra
      selectedItemColor: Colors.blue,
      // Cor do ícone selecionado
      unselectedItemColor: Colors.white,
      // Cor do ícone não selecionado
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
    );
  }

  Widget _buildIconWithElipse(int index, IconData icon, String label) {
    bool isSelected = selectedIndex == index;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: isSelected
              ? BoxDecoration(
                  color: Color(0xFF000080), // Cor da elipse
                  borderRadius: BorderRadius.circular(
                      20), // Borda arredondada mais elíptica
                )
              : null,
          padding: EdgeInsets.symmetric(
              horizontal: 18, vertical: 4), // Tamanho da elipse
          child: Icon(
            icon,
            color: isSelected ? Colors.blue : Colors.white, // Cor do ícone
            size: 25, // Tamanho do ícone
          ),
        ),
        SizedBox(height: 4), // Espaço entre o ícone e o texto
        Text(
          label,
          style: TextStyle(
            color:
                isSelected ? Color(0xFF000080) : Colors.white, // Cor do texto
            fontSize: 12, // isSelected ? 16 : 12, // Tamanho do texto
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
