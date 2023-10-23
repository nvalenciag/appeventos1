import 'package:appeventos/app/ui/pages/chat_group/chat_group_page.dart';
import 'package:appeventos/app/ui/pages/favorites/favorites_page.dart';
import 'package:appeventos/app/ui/pages/home/home_page.dart';
import 'package:appeventos/app/ui/pages/search/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/ui.dart';

import '../../global_widgets/menu_bar/controller/menu_bar_provider.dart';
import '../../global_widgets/menu_bar/menu_bar.dart';
import '../profile/profile_page.dart';



class InitPage extends StatefulWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
   static const List<Widget> _widgetsBody = <Widget>[
    HomePage(),
    FavoritesPage(),
    ChatGroupPage(),
    ProfilePage()
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    bottomNavigationBar: MenuBar(),
      body: Consumer(builder: (context, ref, child) {
        final controller =ref.watch(menuBarProvider);
        return _widgetsBody.elementAt(controller.selectedIndex);
      },),
    );
  }
}
  