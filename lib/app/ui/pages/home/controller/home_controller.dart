import 'package:appeventos/app/dependecy_inyector/inyector.dart';
import 'package:appeventos/app/domain/entities/activity.dart';
import 'package:appeventos/app/domain/entities/event.dart';
import 'package:flutter_meedu/meedu.dart';
import 'package:intl/intl.dart';

class HomeController extends SimpleNotifier {
  final Inyector _inyector = Get.find<Inyector>();

  bool isLoadingEvent = false;
  bool isCompleteEvent = true;
  String dateActivity =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  int pageEvent = 0;
  int sizePage = 6;

  List<Event>? listEvent = [];

  HomeController() {
    /*_inyector.getFavoritesNews();*/
    loadEvent();
  }
  Future<void> searchUserByTitle(String title) async {
    isLoadingEvent = true;
    isCompleteEvent = true;
    pageEvent = 0;
    listEvent = await [];
    dateActivity = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    notify();
    List<Event> temp = (await _inyector.eventService!
        .getEventRencents(pageEvent, 100, dateActivity.toString()))!;

    temp.removeWhere(
        (e) => !e.title.toUpperCase().contains(title.toUpperCase()));

    if (temp.isNotEmpty) {
      listEvent = temp;
    }

    isLoadingEvent = false;
    notify();
  }

  void loadEvent() async {
    isLoadingEvent = true;
    await _loadingEvent();
    isLoadingEvent = false;
    notify();
  }

  Future<void> resetAndRefreshEvent() async {
    isLoadingEvent = false;
    isCompleteEvent = true;
    pageEvent = 0;
    listEvent = [];
    loadEvent();
    /*await _inyector.getFavoritesNews();*/
  }

  Future<void> resetAndRefresh() async {
    dateActivity = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    isLoadingEvent = false;
    isCompleteEvent = true;
    pageEvent = 0;
    sizePage = 6;
    listEvent = [];
    loadEvent();
    /*await _inyector.getFavoritesNews();*/
  }

  _loadingEvent() async {
    List<Event> temp = (await _inyector.eventService!
        .getEventRencents(pageEvent, sizePage, dateActivity.toString()))!;
    pageEvent++;
    if (temp.isNotEmpty) {
      listEvent?.addAll(temp);
    }
  }
}
