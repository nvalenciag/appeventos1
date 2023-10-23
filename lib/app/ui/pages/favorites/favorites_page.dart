import 'package:appeventos/app/ui/pages/favorites/controller/favorites_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/meedu.dart';
import 'package:flutter_meedu/ui.dart';
import '../../../dependecy_inyector/inyector.dart';
import '../../../domain/entities/event.dart';
import '../../../domain/entities/news.dart';
import '../../global_widgets/event_card/event_card.dart';
import '../../global_widgets/news_card/news_card.dart';
import '../../utils/colors_clei.dart';
import 'controller/favorites_provider.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final ScrollController _scrollControllerEvent = ScrollController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String _searchText = "";

  @override
  void initState() {
    super.initState();

    _scrollControllerEvent.addListener(() {
      if (_scrollControllerEvent.position.pixels ==
          (_scrollControllerEvent.position.maxScrollExtent)) {
        favoritesProvider.read.loadEvent();
      }
    });

    // Aquí irían las inicializaciones adicionales del estado o controladores.
  }

  @override
  Widget build(BuildContext context) {
    // Aquí iría la construcción de la página.
    return Scaffold(
      appBar: _appbar(),
      body: _bodyPage(),
    );
  }

  AppBar _appbar() {
    // Aquí iría la construcción de la AppBar.
    return AppBar(
      title: const Text(
        'Asistiré',
        style:
            TextStyle(color: Colors.white, fontFamily: 'Roboto', fontSize: 30),
      ),
      backgroundColor: ColorsClei.azulOscuro,
      toolbarHeight: 65,
      elevation: 0.0,
    );
  }

  Widget _top() {
    return Center(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(20.0, 20, 12, 20),
                  child: TextField(
                    onChanged: (nuevoTexto) {
                      setState(() {
                        _searchText =
                            nuevoTexto; // Actualiza el valor de _texto cuando cambie el texto
                      });
                    },
                    maxLines: null, // Permite múltiples líneas
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Busca por titulo',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              10.0)), // Bordes rectangulares
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 21, 0),
                child: FloatingActionButton(
                    backgroundColor: ColorsClei.azulCielo,
                    onPressed: (() => {
                          favoritesProvider.read.searchUserByTitle(_searchText)
                        }),
                    child: Icon(Icons.search)),
              ),
            ],
          ),
          Expanded(
            child: Container(
              width: 450,
              margin: const EdgeInsets.symmetric(horizontal: 0),
              child: Container(
                child: _loadingEventWidget(),
              ),
            ),
          )
        ],
      ),
    );
  }

  _bodyPage() {
    return RefreshIndicator(
        onRefresh: () {
          return favoritesProvider.read.resetAndRefresh();
        },
        child: _top());
  }

  Consumer _loadingEventWidget() {
    return Consumer(
      builder: (context, ref, child) {
        final controller = ref.watch(favoritesProvider);
        if (controller.isLoadingEvent) {
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
          List<Event> listEvent = controller.listEvent!;
          return ListView(
            controller: _scrollControllerEvent,
            padding: const EdgeInsets.all(8),
            scrollDirection: Axis.vertical,
            children: () {
              List<Widget> eventCards = [];

              /*List<int>? listFavorites = inyector.idsFavoritesNews;*/

              for (Event event in listEvent) {
                /* bool isFavorite = listFavorites!.contains(event.id);*/
                eventCards.add(event.attendance
                    ? Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: EventCard(
                            sizeImage: 415,
                            /*isFavorite: isFavorite,*/
                            event: Event(
                                id: event.id,
                                title: event.title,
                                description: event.description,
                                place: event.place,
                                eventState: event.eventState,
                                photo: event.photo,
                                eventType: event.eventType,
                                attendance: event.attendance,
                                date: event.date)))
                    : Container());
              }

              eventCards.add(Container(height: 700));

              return eventCards;
            }(),
          );
        }
      },
    );
  }
}
