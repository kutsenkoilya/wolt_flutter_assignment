import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wolt_flutter_assignment/features/location/data/models/phone_location.dart';
import 'package:wolt_flutter_assignment/features/venues/data/models/venue.dart';
import 'package:wolt_flutter_assignment/features/venues/data/repositories/favorites_repository.dart';
import 'package:wolt_flutter_assignment/features/venues/data/repositories/venue_repository.dart';
import 'package:wolt_flutter_assignment/features/venues/venue_provider.dart';

class MockVenueRepository extends Mock implements VenueRepository {}
class MockFavoriteVenuesRepository extends Mock implements FavoriteVenuesRepository {}

void main() {
  final getIt = GetIt.instance;

  setUpAll(() {
    getIt.registerLazySingleton<VenueRepository>(() => MockVenueRepository());
    getIt.registerLazySingleton<FavoriteVenuesRepository>(() => MockFavoriteVenuesRepository());
  });

  tearDownAll(() {
    getIt.reset();
  });

  group('VenueProviderImpl', () {
    late MockVenueRepository mockVenueRepository;
    late MockFavoriteVenuesRepository mockFavoriteVenuesRepository;
    late VenueProviderImpl venueProvider;
    const int venueLimit = 15;

    setUp(() {
      mockVenueRepository = getIt<VenueRepository>() as MockVenueRepository;
      mockFavoriteVenuesRepository = getIt<FavoriteVenuesRepository>() as MockFavoriteVenuesRepository;

      venueProvider = VenueProviderImpl(
        venueLimit: venueLimit,
      );
    });

    test('fetchVenues returns a limited list of venues', () async {
      final location = PhoneLocation(latitude: 37.7749, longitude: -122.4194);
      final mockVenues = List.generate(20, (index) => Venue(
        id: '$index',
        url: 'https://example.com/image$index.jpg',
        name: 'Venue $index',
        description: 'Description $index',
        isFavorite: false,
      ));

      when(() => mockVenueRepository.getNearbyVenues(location))
          .thenAnswer((_) async => mockVenues);
      when(() => mockFavoriteVenuesRepository.getFavoriteVenueIds())
          .thenAnswer((_) async => []);

      final venues = await venueProvider.getNearbyVenues(location);

      expect(venues, isA<List<Venue>>());
      expect(venues.length, venueLimit);
    });

    test('fetchVenues returns an empty list when no venues are found', () async {
      final location = PhoneLocation(latitude: 37.7749, longitude: -122.4194);
      when(() => mockVenueRepository.getNearbyVenues(location))
          .thenAnswer((_) async => []);
      when(() => mockFavoriteVenuesRepository.getFavoriteVenueIds())
          .thenAnswer((_) async => []);

      final venues = await venueProvider.getNearbyVenues(location);

      expect(venues, isEmpty);
    });
  });
}