import 'package:flutter_meedu/meedu.dart';
import 'package:intl/intl.dart';

import '../../../../dependecy_inyector/inyector.dart';
import '../../../../domain/entities/event.dart';
import '../../../../domain/entities/news.dart';

class FavoritesController extends SimpleNotifier {
  final Inyector _inyector = Get.find<Inyector>();

  bool isLoadingNews = false;
  bool isCompleteNews = true;
  FavoritesController() {
    //loadEvent();
    //loadNews();
  } 

  List<News>? listNews = [];

  // void cargarFavoritos(){
  //   notify();

  // }
  void loadNews() async {
    isLoadingNews = true;
    await _loadingNews();
    isLoadingNews = false;
    notify();
  }

  _loadingNews() async {
    listNews = [];
    List<News> temp = (await _inyector.newsService!.getAllNews())!;
    listNews!.addAll(temp);
    print(listNews);
  }

  bool isLoadingEvent = false;
  bool isCompleteEvent = true;
  String dateActivity =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  int pageEvent = 0;
  int sizePage = 100;

  List<Event>? listEvent = [];

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
    sizePage = 100;
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

  Future<void> searchUserByTitle(String title) async {
    isLoadingEvent = true;
    isCompleteEvent = true;
    pageEvent = 0;
    listEvent = [];
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
}
