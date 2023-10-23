import 'package:appeventos/app/domain/entities/news.dart';
import 'package:equatable/equatable.dart';

class ListNews extends Equatable{

  final List<News> listNews;

  const ListNews({required this.listNews});

  ListNews copyWith({List<News>? news}) =>
      ListNews(listNews: news ?? listNews);

    factory ListNews.fromJson(List<dynamic> json){
    final listNews = json.map((e) => News.fromJson(e)).toList();
    return ListNews(listNews: listNews);
  }
  
  @override
  List<Object?> get props => [listNews];

}