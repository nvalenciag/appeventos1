import 'package:equatable/equatable.dart';

class NewsPhotos extends Equatable{

  final List<String> newsPhotos;

  const NewsPhotos({required this.newsPhotos});

  NewsPhotos copyWith({List<String>? news}) =>
      NewsPhotos(newsPhotos: news ?? newsPhotos);

    factory NewsPhotos.fromJson(List<dynamic> json){
    final  List<String> newsPhotos = json.map((e) {
      return e.toString();
    },).toList();
    return NewsPhotos(newsPhotos: newsPhotos);
  }
  
  @override
  List<Object?> get props => [newsPhotos];

}