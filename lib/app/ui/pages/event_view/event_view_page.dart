import 'package:appeventos/app/data/data_source/remote/activity_service_impl.dart';

import 'package:appeventos/app/dependecy_inyector/inyector.dart';
import 'package:appeventos/app/domain/entities/activity.dart';
import 'package:appeventos/app/domain/entities/event.dart';
import 'package:appeventos/app/domain/entities/news.dart';
import 'package:appeventos/app/domain/repositories/activity_service.dart';
import 'package:appeventos/app/ui/global_widgets/news_card/news_card.dart';
import 'package:appeventos/app/ui/pages/event_view/controller/event_view_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/ui.dart';
import '../../global_widgets/activity_card/activity_card.dart';
import '../../routes/routes.dart';
import '../../utils/colors_clei.dart';
import 'package:flutter_meedu/meedu.dart';

class EventViewPage extends StatefulWidget {
  const EventViewPage({Key? key}) : super(key: key);

  @override
  State<EventViewPage> createState() => _EventViewPageState();
}

class _EventViewPageState extends State<EventViewPage> {
  Inyector inyector = Get.find<Inyector>();

  final ScrollController _scrollControllerActivity = ScrollController();
  final ScrollController _scrollControllerNews = ScrollController();
  List<Object> listArguments = [];
  late Event event;
  String text="";

  @override
  void initState() {
    super.initState();

    _scrollControllerActivity.addListener(() {
      if (_scrollControllerActivity.position.pixels ==
          _scrollControllerActivity.position.maxScrollExtent) {
        eventViewProvider.read.loadActivities(event.id);
      }
    });

    _scrollControllerNews.addListener(() {
      if (_scrollControllerNews.position.pixels ==
          _scrollControllerNews.position.maxScrollExtent) {
        eventViewProvider.read.loadNews(event.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    listArguments = router.arguments as List<Object>;
    event = listArguments[0] as Event;
    eventViewProvider.read.loadAll(event.id);
    return Scaffold(appBar: _appbar(), body: _bodyPage());
  }

  AppBar _appbar() {
    return AppBar(
      title: const Text(
        'Información del Evento',
        style:
            TextStyle(color: Colors.white, fontFamily: 'Roboto', fontSize: 30),
      ),
      backgroundColor: ColorsClei.azulOscuro,
      toolbarHeight: 65,
      elevation: 0.0,
      iconTheme: IconThemeData(color: Colors.white, size: 34),
    );
  }

  _bodyPage() {
    return RefreshIndicator(
      onRefresh: () {
        return eventViewProvider.read.resetAndRefresh();
      },
      child: ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.only(bottom: 15, top: 15, left: 15),
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 15, 10),
                  child: Text(
                    textAlign: TextAlign.justify,
                    event.title,
                    style: TextStyle(fontSize: 29, color: ColorsClei.azulCielo),
                    softWrap: true, // Permite que el texto salte en línea
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 15, 10),
                  child: Text(
                    textAlign: TextAlign.justify,
                    event.description,
                    style: TextStyle(fontSize: 17, color: Colors.black),
                    softWrap: true, // Permite que el texto salte en línea
                  ),
                ),
                createHead('Actividades'),
                Container(
                    height: 170,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: _loadingActivitiesWidget()),
                createHead('Noticias'),
                Container(
                  height: 350,
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: _loadingNewsWidget(),
                )
              ],
            ),
          ]),
    );
  }

  Row createHead(
    String titleText,
  ) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titleText,
            style: const TextStyle(
                color: ColorsClei.azulOscuro,
                fontFamily: 'Roboto',
                fontSize: 30),
          ),
          ElevatedButton(
              onPressed: () {
                if (titleText == 'Actividades') {
                  router.pushNamed(Routes.ALL_ACTIVITIES);
                } else {
                  router.pushNamed(Routes.ALL_NEWS);
                }
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.transparent, elevation: 0),
              child: const Text('Todos >',
                  style: TextStyle(
                      color: ColorsClei.azulOscuro,
                      fontFamily: 'Roboto',
                      fontSize: 20)))
        ],
      );

  Consumer _loadingActivitiesWidget() {
    return Consumer(
      builder: (context, ref, child) {
        final controller = ref.watch(eventViewProvider);
        if (controller.isLoadingActivities) {
          return Stack(children: const [
            Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            ),
          ]);
        } else {
          List<Activity> activity = controller.activity!;
          return ListView(
            controller: _scrollControllerActivity,
            padding: const EdgeInsets.all(8),
            scrollDirection: Axis.horizontal,
            children: () {
              List<Widget> activityCard = [];
              for (Activity activity in activity) {
                activityCard.add(ActivityCard(
                    activityData: Activity(
                        id: activity.id,
                        title: activity.title,
                        room: activity.room,
                        date: activity.date,
                        duration: activity.duration,
                        authors: activity.authors)));
              }
              if (activityCard.length < 1) {
                activityCard.add(Row(
                  children: [
                    Center(
                        child: Text(
                      "No hay actividades para mostrar",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    )),
                  ],
                ));
              }
              return activityCard;
            }(),
          );
        }
      },
    );
  }

  Consumer _loadingNewsWidget() {
    return Consumer(
      builder: (context, ref, child) {
        final controller = ref.watch(eventViewProvider);
        if (controller.isLoadingNews) {
          return Stack(children: const [
            Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            ),
          ]);
        } else {
          List<News> listNews = controller.listNews!;
          return ListView(
            controller: _scrollControllerNews,
            padding: const EdgeInsets.all(8),
            scrollDirection: Axis.horizontal,
            children: () {
              List<Widget> newsCards = [];

              List<int>? listFavorites = inyector.idsFavoritesNews;
              for (News news in listNews) {
                bool isFavorite = listFavorites!.contains(news.id);
                newsCards.add(NewsCard(
                    sizeImage: 280,
                    isFavorite: isFavorite,
                    news: News(
                        id: news.id,
                        title: news.title,
                        description: news.description,
                        dateCreation: news.dateCreation,
                        urlPreviewPhoto: news.urlPreviewPhoto,
                        urlNewsContent: news.urlNewsContent)));
              }
              if (newsCards.length < 1) {
                newsCards.add(Row(
                  children: [
                    Text(
                      "No hay noticias para mostrar",
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ));
              }
              return newsCards;
            }(),
          );
        }
      },
    );
  }
}
