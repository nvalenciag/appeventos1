import 'package:appeventos/app/dependecy_inyector/inyector.dart';
import 'package:appeventos/app/domain/entities/activity.dart';
import 'package:appeventos/app/domain/entities/news.dart';
import 'package:flutter_meedu/meedu.dart';
import 'package:intl/intl.dart';

class EventViewController extends SimpleNotifier {
  final Inyector _inyector = Get.find<Inyector>();

  bool isLoadingActivities = false;
  bool isLoadingNews = false;
  bool isCompleteActivities = true;
  bool isCompleteNews = true;
  String dateActivity =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  int pageActivity = 0;
  int pageNews = 0;
  int sizePage = 3;
  int idEvent=-1;

  List<Activity>? activity = [];
  List<News>? listNews = [];

  EventViewController() {
    _inyector.getFavoritesNews();
   
  }
  void loadAll(int idEvent){
    print(idEvent);
    this.idEvent=idEvent;
     loadActivities(idEvent);
    loadNews(idEvent);
  }

  void loadActivities(idEvent) async {
    isLoadingActivities = true;
    await _loadingActivities(idEvent);
    isLoadingActivities = false;
    notify();
  }

  _loadingActivities(idEvent) async {
    List<Activity> temp = (await _inyector.activityService!
        .getAllActivitiesAfter(
            pageActivity, sizePage, dateActivity.toString(),idEvent))!;

    pageActivity++;
    if (temp.isNotEmpty) {
      activity?.addAll(temp);
    }
  }

  void loadNews(idEvent) async {
    isLoadingNews = true;
    await _loadingNews(idEvent);
    isLoadingNews = false;
    notify();
  }

  Future<void> resetAndRefreshNews() async {
    isLoadingNews = false;
    isCompleteActivities = true;
    isCompleteNews = true;
    pageNews = 0;
    listNews = [];
    loadNews(idEvent);
    await _inyector.getFavoritesNews();
  }

  Future<void> resetAndRefresh() async {
    dateActivity = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    isLoadingActivities = false;
    isLoadingNews = false;
    isCompleteActivities = true;
    isCompleteNews = true;
    pageActivity = 0;
    pageNews = 0;
    sizePage = 3;
    activity = [];
    listNews = [];
    loadActivities(idEvent);
    loadNews(idEvent);
    await _inyector.getFavoritesNews();
  }

  _loadingNews(idEvent) async {
    List<News> temp = (await _inyector.newsService!
        .getNewsRencents(pageNews, sizePage, dateActivity.toString(),idEvent))!;
    pageNews++;
    if (temp.isNotEmpty) {
      listNews?.addAll(temp);
    }
  }
}
