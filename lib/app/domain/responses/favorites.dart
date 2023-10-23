import 'package:appeventos/app/domain/entities/news.dart';
import 'package:equatable/equatable.dart';

class Favorites extends Equatable{

  final List<int> listFavorites;

  const Favorites({required this.listFavorites});

  Favorites copyWith({List<int>? favorites}) =>
      Favorites(listFavorites: favorites ?? listFavorites);

    factory Favorites.fromJson(List<dynamic> json){
    final listFavorites = json.map((e) {
      return int.parse(e.toString());
    },).toList();
    return Favorites(listFavorites: listFavorites);
  }
  
  @override
  List<Object?> get props => [listFavorites];
}