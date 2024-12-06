import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../services/logger_service.dart';

abstract class FavoriteVenuesRepository {
  Future<List<String>> getFavoriteVenueIds();
  Future addFavoriteVenue(String id);
  Future removeFavoriteVenue(String id);
}

class FavoritesRepositoryImpl implements FavoriteVenuesRepository {
  static const String _favoritesKey = 'favorites';

  final LoggerService _logger = GetIt.I<LoggerService>();
  final SharedPreferences _sharedPreferences = GetIt.I<SharedPreferences>();

  @override
  Future<List<String>> getFavoriteVenueIds() async {
    return _sharedPreferences.getStringList(_favoritesKey) ?? [];
  }

  @override
  Future<void> addFavoriteVenue(String id) async {
    _logger.info("Favorite added: $id");
    final favoriteIds = _sharedPreferences.getStringList(_favoritesKey) ?? [];
    if (!favoriteIds.contains(id)) {
      favoriteIds.add(id);
      await _sharedPreferences.setStringList(_favoritesKey, favoriteIds);
    }
  }

  @override
  Future<void> removeFavoriteVenue(String id) async {
    _logger.info("Favorite removed: $id");
    final favoriteIds = _sharedPreferences.getStringList(_favoritesKey) ?? [];
    favoriteIds.remove(id);
    await _sharedPreferences.setStringList(_favoritesKey, favoriteIds);
  }
}