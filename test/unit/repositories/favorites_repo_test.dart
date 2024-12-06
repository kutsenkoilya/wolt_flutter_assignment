import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wolt_flutter_assignment/features/venues/data/repositories/favorites_repository.dart';
import 'package:wolt_flutter_assignment/services/logger_service.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  final getIt = GetIt.instance;

  setUpAll(() {
    getIt.registerLazySingleton<LoggerService>(() => LoggerService('TestLogger'));
    getIt.registerLazySingleton<SharedPreferences>(() => MockSharedPreferences());
  });

  tearDownAll(() {
    getIt.reset();
  });

  group('FavoritesRepositoryImpl', () {
    late MockSharedPreferences mockSharedPreferences;
    late FavoritesRepositoryImpl favoritesRepository;

    setUp(() {
      mockSharedPreferences = getIt<SharedPreferences>() as MockSharedPreferences;
      favoritesRepository = FavoritesRepositoryImpl();
    });

    test('getFavoriteVenueIds returns list of favorite venue IDs', () async {
      when(() => mockSharedPreferences.getStringList(any())).thenReturn(['1', '2', '3']);
      SharedPreferences.setMockInitialValues({'favoriteVenues': ['1', '2', '3']});

      final favoriteIds = await favoritesRepository.getFavoriteVenueIds();

      expect(favoriteIds, ['1', '2', '3']);
    });

    test('addFavoriteVenue adds a new favorite venue ID', () async {
      when(() => mockSharedPreferences.getStringList(any())).thenReturn(['1', '2']);
      when(() => mockSharedPreferences.setStringList(any(), any())).thenAnswer((_) async => true);
      SharedPreferences.setMockInitialValues({'favoriteVenues': ['1', '2']});

      await favoritesRepository.addFavoriteVenue('3');
      final favoriteIds = await favoritesRepository.getFavoriteVenueIds();

      expect(favoriteIds, ['1', '2', '3']);
    });

    test('removeFavoriteVenue removes an existing favorite venue ID', () async {
      when(() => mockSharedPreferences.getStringList(any())).thenReturn(['1', '2', '3']);
      when(() => mockSharedPreferences.setStringList(any(), any())).thenAnswer((_) async => true);
      SharedPreferences.setMockInitialValues({'favoriteVenues': ['1', '2', '3']});

      await favoritesRepository.removeFavoriteVenue('2');
      final favoriteIds = await favoritesRepository.getFavoriteVenueIds();

      expect(favoriteIds, ['1', '3']);
    });
  });
}