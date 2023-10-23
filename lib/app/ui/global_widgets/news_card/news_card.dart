import 'package:appeventos/app/domain/entities/news.dart';
import 'package:appeventos/app/ui/routes/routes.dart';
import 'package:appeventos/app/ui/utils/colors_clei.dart';
import 'package:appeventos/app/ui/utils/icons_clei_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meedu/ui.dart';
import 'package:intl/intl.dart';

class NewsCard extends StatelessWidget {
  final News news;
  final bool isFavorite;
  final double sizeImage;

  const NewsCard(
      {Key? key,
      required this.news,
      required this.isFavorite,
      required this.sizeImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        router.pushNamed(Routes.NEWS_VIEW, arguments: [news, isFavorite]);
      },
      child: Container(
          height: 350,
          width: 280,
          margin: const EdgeInsets.only(right: 15),
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            border: Border.all(color: ColorsClei.gris, width: 1),
          ),
          child: Container(
            width: sizeImage,
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                FadeInImage(
                  image: NetworkImage(news.urlPreviewPhoto),
                  placeholder: const AssetImage('assets/default_image.png'),
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/default_image.png',
                        fit: BoxFit.fitWidth);
                  },
                  fit: BoxFit.fitHeight,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: contentCard(context),
                ),
              ],
            ),
          )),
    );
  }

  Container contentCard(context) {
    return Container(
      height: 220,
      width: sizeImage - 50,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 4),
            height: 150,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: ColorsClei.grisClaro, width: 1)),
            child: Stack(
              children: [
                Align(
                    alignment: Alignment.topRight,
                    child: () {
                      if (isFavorite) {
                        return const Icon(
                          IconsClei.favorito_2,
                          color: Colors.red,
                        );
                      }

                      return Container();
                    }()),
                Center(child: titleNews(context)),
                Align(
                  alignment: Alignment.bottomRight,
                  child: dateCreationNews(),
                )
              ],
            ),
          ),
          descriptionNews(context)
        ],
      ),
    );
  }

  Text dateCreationNews() {
    return Text(DateFormat.MMMd('es').format(news.dateCreation),
        style: const TextStyle(
            fontFamily: 'Roboto', fontSize: 14, color: ColorsClei.gris));
  }

  Padding descriptionNews(context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Text(news.description,
            textAlign: TextAlign.justify,
            style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: MediaQuery.of(context).size.width * 0.029,
                height: 1),
            maxLines: 3,
            overflow: TextOverflow.ellipsis));
  }

  Padding titleNews(context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Text(
        news.title,
        style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: MediaQuery.of(context).size.width * 0.05),
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
