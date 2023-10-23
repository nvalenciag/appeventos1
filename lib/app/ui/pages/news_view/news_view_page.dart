import 'dart:convert';

import 'package:appeventos/app/domain/entities/news.dart';
import 'package:appeventos/app/domain/utils/config.dart';
import 'package:appeventos/app/ui/pages/favorites/controller/favorites_provider.dart';
import 'package:appeventos/app/ui/pages/event_view/controller/event_view_provider.dart';
import 'package:appeventos/app/ui/utils/colors_clei.dart';
import 'package:appeventos/app/ui/utils/icons_clei_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/ui.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';

import 'controller/news_view_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_quill/flutter_quill.dart' as quill;

class NewsViewPage extends StatefulWidget {
  const NewsViewPage({Key? key}) : super(key: key);

  @override
  State<NewsViewPage> createState() => _NewsViewPageState();
}

class _NewsViewPageState extends State<NewsViewPage> {
  quill.QuillController? _controller;
  FocusNode _focusNode = FocusNode();
  List<Object> listArguments = [];

  @override
  void initState() {
    super.initState();
    listArguments = router.arguments as List<Object>;
    News news = listArguments[0] as News;
    _loadFromAssets(news.urlNewsContent);
  }

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();

    News news = listArguments[0] as News;

    if (_controller == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    bool isFavorite = listArguments[1] as bool;
    newsViewProvider.read.setisFavorite(isFavorite);
    newsViewProvider.read.getNewsPhotos(news.id);
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Noticias',
            style: TextStyle(
                color: ColorsClei.azulOscuro,
                fontFamily: 'Roboto',
                fontSize: 35),
          ),
          leading: IconButton(
            icon: const Icon(
              IconsClei.flecha,
              color: ColorsClei.azulOscuro,
            ),
            onPressed: () {
              router.pop();
              eventViewProvider.read.resetAndRefreshNews();
            },
          ),
          actions: [
            IconButton(
              padding: const EdgeInsets.only(right: 3),
              icon: const Icon(
                IconsClei.compartir,
                color: ColorsClei.gris,
              ),
              onPressed: () {
                Share.share('https://appeventos.page.link/news-1');
              },
            )
          ],
          backgroundColor: Colors.white,
          toolbarHeight: 65,
          elevation: 0.0),
      body: ListView(scrollDirection: Axis.vertical, children: [
        Column(
          children: [
            header(controller, news),
            quill.QuillEditor(
              enableInteractiveSelection: false,
              controller: _controller!,
              scrollController: ScrollController(),
              scrollable: true,
              autoFocus: false,
              readOnly: true,
              expands: false,
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
              focusNode: _focusNode,
            ),
          ],
        ),
      ]),
    );
  }

  Consumer header(PageController controller, News news) {
    return Consumer(
      builder: (context, ref, child) {
        final controler = ref.watch(newsViewProvider);
        List<Widget> photos = [];
        return Container(
          //decoration: BoxDecoration(color: Colors.yellow),
          alignment: Alignment.topCenter,
          height: 370,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              PageView(
                controller: controller,
                onPageChanged: (value) {
                  controler.changeIndexDot(value);
                },
                children: () {
                  List<String> routePhotos = controler.newsPhotos!;
                  for (String route in routePhotos) {
                    photos.add(
                      Container(
                        height: 150,
                        alignment: Alignment.topCenter,
                        child: FadeInImage(
                          image: NetworkImage(route),
                          placeholder:
                              const AssetImage('assets/default_image.png'),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset('assets/default_image.png',
                                fit: BoxFit.fitWidth);
                          },
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    );
                  }
                  return photos;
                }(),
              ),
              IgnorePointer(
                child: Container(
                  margin: const EdgeInsets.only(top: 200, left: 20, right: 20),
                  height: 155,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: ColorsClei.gris, width: 1)),
                  child: Stack(
                    children: [
                      Center(child: titleNews(news.title)),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: dateCreationNews(news.dateCreation)),
                    ],
                  ),
                ),
              ),
              IgnorePointer(
                  child: Container(
                margin: const EdgeInsets.only(top: 190, left: 20, right: 20),
                height: 50,
                child: Consumer(
                  builder: (context, ref, child) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: indicators(photos.length,
                            ref.watch(newsViewProvider).indexDot));
                  },
                ),
              )),
            ],
          ),
        );
      },
    );
  }

  IconButton buttonFavorite(News news) {
    return IconButton(
        icon: Consumer(builder: (context, ref, child) {
          final controler = ref.watch(newsViewProvider);
          if (controler.isButtonFavorite) {
            return const Icon(IconsClei.favorito, color: ColorsClei.azulOscuro);
          }
          return const Icon(IconsClei.favorito, color: ColorsClei.gris);
        }),
        padding: const EdgeInsets.only(right: 13),
        onPressed: () {
          newsViewProvider.read.isChangeFavoriteState(news.id);
        });
  }

  Padding titleNews(String title) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Text(
        title,
        style: const TextStyle(fontFamily: 'Roboto', fontSize: 33),
        maxLines: 3,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Text dateCreationNews(DateTime fecha) {
    return Text('${DateFormat.yMMMd('es').format(fecha)} ',
        style: const TextStyle(
            fontFamily: 'Roboto', fontSize: 20, color: ColorsClei.gris));
  }

  Future<void> _loadFromAssets(String urlContent) async {
    try {
      final resp = await http.get(Uri.parse(Config.url + urlContent));
      final doc = quill.Document.fromJson(jsonDecode(utf8.decode(resp.bodyBytes)));

      setState(() {
        _controller = quill.QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
      });
    } catch (error) {
      final doc = quill.Document()..insert(0, 'Empty asset');
      setState(() {
        _controller = quill.QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
      });
    }
  }

  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: EdgeInsets.all(5),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color:
                currentIndex == index ? ColorsClei.azulOscuro : Colors.black26,
            shape: BoxShape.circle),
      );
    });
  }
}
