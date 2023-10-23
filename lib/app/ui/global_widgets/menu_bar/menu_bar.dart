import 'package:appeventos/app/ui/global_widgets/menu_bar/controller/menu_bar_provider.dart';
import 'package:appeventos/app/ui/utils/colors_clei.dart';
import 'package:appeventos/app/ui/utils/icons_clei_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/ui.dart';

class MenuBar extends StatefulWidget {
  MenuBar({Key? key}) : super(key: key);

  @override
  State<MenuBar> createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> {
  TextStyle estiloTexto = const TextStyle(
      fontFamily: 'Roboto', fontSize: 17.0, height: 1.5);
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final controller = ref.watch(menuBarProvider);
        return BottomNavigationBar(
            iconSize: 30,
            items: const [
              BottomNavigationBarItem(
                backgroundColor: ColorsClei.grisClaro,
                icon: Icon(
                  Icons.home_rounded,
                  size: 32,
                ),
                label: 'Principal',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.library_add_check,
                  size: 27,
                ),
                label: 'Asistiré',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.question_answer_rounded ,
                  size: 30,
                ),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  size: 34,
                ),
                label: 'Perfil',
              ),
            ],
            showSelectedLabels: true,
            showUnselectedLabels: true,
            unselectedLabelStyle: estiloTexto,
            selectedLabelStyle: estiloTexto,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.white,
            unselectedItemColor: Color.fromARGB(255, 219, 219, 219),
            backgroundColor: Color(0xFF308113),
            elevation: 0.0,
            currentIndex: controller.selectedIndex,
            onTap: controller.onItemTapped);
      },
    );
  }
}
