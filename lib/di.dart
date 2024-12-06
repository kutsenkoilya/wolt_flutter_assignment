import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wolt_flutter_assignment/features/location/locaiton_service.dart';
import 'package:wolt_flutter_assignment/features/venues/data/datasources/venue_api_client.dart';
import 'package:wolt_flutter_assignment/features/venues/data/repositories/favorites_repository.dart';
import 'package:wolt_flutter_assignment/features/venues/venue_provider.dart';
import 'package:wolt_flutter_assignment/services/logger_service.dart';
import 'package:wolt_flutter_assignment/services/wolt_api_client.dart';
import 'package:flutter/foundation.dart';
import 'features/venues/data/repositories/venue_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupLocator() async {
  final logLevel = dotenv.env['LOG_LEVEL'] ?? 'INFO';
  Logger.root.level = _parseLogLevel(logLevel);

  if (!kReleaseMode) {
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
      if (record.error != null) {
        print('Error: ${record.error}');
      }
      if (record.stackTrace != null) {
        print('StackTrace: ${record.stackTrace}');
      }
    });
  }

  var baseUrl = dotenv.env['WOLT_BASE_URL'] ?? 'https://restaurant-api.wolt.com/v1';
  var venueLimit = int.parse(dotenv.env['VENUE_LIMIT'] ?? '15');
  var locationUpdateSeconds = int.parse(dotenv.env['LOCATION_UPDATE_SECONDS'] ?? '10');
  var useMockLocation = int.parse(dotenv.env['USE_MOCK_LOCATION'] ?? '1') ;

  GetIt.instance.registerLazySingletonAsync<SharedPreferences>(
        () => SharedPreferences.getInstance(),
  );
  await GetIt.instance.isReady<SharedPreferences>();

  getIt.registerLazySingleton(() => LoggerService('MyApp'));
  getIt.registerLazySingleton<http.Client>(() => http.Client());
  getIt.registerLazySingleton<WoltApiClient>(() => WoltApiClientImpl(baseUrl: baseUrl));
  getIt.registerLazySingleton<VenueApiClient>(() => VenueApiClientImpl());
  getIt.registerLazySingleton<VenueRepository>(() => VenueRepositoryImpl());
  getIt.registerLazySingleton<FavoriteVenuesRepository>(() => FavoritesRepositoryImpl());
  if (useMockLocation == 1)
  {
    getIt.registerLazySingleton<LocationService>(() => MockLocationServiceImpl(locationUpdateSeconds: locationUpdateSeconds));
  }
  else
  {
    getIt.registerLazySingleton<LocationService>(() => LocationServiceImpl(locationUpdateSeconds: locationUpdateSeconds));
  }
  getIt.registerLazySingleton<VenueProvider>(() => VenueProviderImpl(venueLimit: venueLimit));
}

Level _parseLogLevel(String level) {
  switch (level.toUpperCase()) {
    case 'ALL':
      return Level.ALL;
    case 'FINE':
      return Level.FINE;
    case 'INFO':
      return Level.INFO;
    case 'WARNING':
      return Level.WARNING;
    case 'SEVERE':
      return Level.SEVERE;
    case 'OFF':
      return Level.OFF;
    default:
      return Level.INFO;
  }
}