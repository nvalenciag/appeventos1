import 'package:appeventos/app/ui/global_widgets/event_card/event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/ui.dart';

import '../../../domain/entities/event.dart';
import '../../utils/colors_clei.dart';
import 'package:appeventos/app/ui/pages/home/controller/home_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollControllerEvent = ScrollController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String _searchText = "";

  @override
  void initState() {
    super.initState();

    _scrollControllerEvent.addListener(() {
      if (_scrollControllerEvent.position.pixels ==
          (_scrollControllerEvent.position.maxScrollExtent)) {
        homeProvider.read.loadEvent();
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
        'Lista de Eventos',
        style: TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
            fontSize: 30),
      ),
      backgroundColor: ColorsClei.azulOscuro,
      toolbarHeight: 65,
      elevation: 0.0,
    );
  }

  _bodyPage() {
    return RefreshIndicator(
        onRefresh: () {
          return homeProvider.read.resetAndRefresh();
        },
        child: Center(
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
                        onPressed: (() =>
                            {homeProvider.read.searchUserByTitle(_searchText)}),
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
        ));
  }

  Consumer _loadingEventWidget() {
    return Consumer(
      builder: (context, ref, child) {
        final controller = ref.watch(homeProvider);
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
                eventCards.add(Padding(
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
                            date: event.date))));
              }
              return eventCards;
            }(),
          );
        }
      },
    );
  }
}
