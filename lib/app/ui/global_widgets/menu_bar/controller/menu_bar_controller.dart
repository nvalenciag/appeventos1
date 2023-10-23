import 'package:appeventos/app/ui/pages/favorites/controller/favorites_provider.dart';
import 'package:appeventos/app/ui/pages/home/controller/home_provider.dart';
import 'package:flutter_meedu/meedu.dart';

class MenuBarController extends SimpleNotifier {
  int selectedIndex = 0;

  void onItemTapped(int index) {
    if (selectedIndex != 0 && index == 0) {
      homeProvider.read.resetAndRefreshEvent();
    } else if (selectedIndex != 1 && index == 1) {
      favoritesProvider.read.resetAndRefresh();
    }
    selectedIndex = index;
    notify();
  }
}
