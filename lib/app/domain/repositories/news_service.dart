import 'package:appeventos/app/domain/entities/news.dart';

abstract class NewsService{
  
  Future<List<News>?> getNewsRencents(int page, int sizePage,String date,int idEvent);
  Future<List<String>?> getNewsPhotos(int idNews);
  Future<List<News>?> getAllNews();
  
}