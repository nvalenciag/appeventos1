import 'package:flutter/material.dart';
import 'package:flutter_meedu/meedu.dart';
import 'package:flutter_meedu/ui.dart';
import '../../../dependecy_inyector/inyector.dart';
import '../../../domain/entities/event.dart';
import '../../../domain/entities/news.dart';
import '../../global_widgets/news_card/news_card.dart';
import '../../utils/colors_clei.dart';
import '../../utils/icons_clei_icons.dart';
import '../favorites/controller/favorites_provider.dart';

class AllNewsPage extends StatelessWidget {
  AllNewsPage({Key? key}) : super(key: key);
  Event? event;

  void initState() {
    print("<<<<<<<<<<<<<<<<");
    var listArguments = router.arguments as List<Object>;
    event = listArguments[0] as Event;
    print(event);
    print("lssssssssssssssssss");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 34,
          ),
          onPressed: () {
            router.pop();
          },
        ),
        title: const Text(
          'Todas las noticias',
          style: TextStyle(
              color: Colors.white, fontFamily: 'Roboto', fontSize: 30),
        ),
        backgroundColor: ColorsClei.azulOscuro,
        toolbarHeight: 65,
        elevation: 0.0,
      ),
      body: Center(child: _bodyPage()),
    );
  }

  _bodyPage() {
    return Container(
      width: 370,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: _loadingNewsWidget(),
    );
  }

  Consumer _loadingNewsWidget() {
    Inyector inyector = Get.find<Inyector>();

    return Consumer(
      builder: (context, ref, child) {
        final controller = ref.watch(favoritesProvider);
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
            padding: const EdgeInsets.only(left: 17),
            scrollDirection: Axis.vertical,
            children: () {
              List<Widget> newsCards = [];

              List<int>? listFavorites = inyector.idsFavoritesNews;
              for (News news in listNews) {
                bool isFavorite = listFavorites!.contains(news.id);

                newsCards.add(Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: NewsCard(
                      sizeImage: 336,
                      isFavorite: isFavorite,
                      news: News(
                          id: news.id,
                          title: news.title,
                          description: news.description,
                          dateCreation: news.dateCreation,
                          urlPreviewPhoto: news.urlPreviewPhoto,
                          urlNewsContent: news.urlNewsContent)),
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
