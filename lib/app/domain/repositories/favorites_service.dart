

abstract class FavoritesService{
  
  Future<List<int>?> getFavorites();

  Future<bool> setFavoriteState(int idNews);
}