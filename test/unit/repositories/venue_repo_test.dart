import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wolt_flutter_assignment/features/location/data/models/phone_location.dart';
import 'package:wolt_flutter_assignment/features/venues/data/datasources/responses/item.dart';
import 'package:wolt_flutter_assignment/features/venues/data/datasources/responses/item_image.dart';
import 'package:wolt_flutter_assignment/features/venues/data/datasources/responses/item_venue.dart';
import 'package:wolt_flutter_assignment/features/venues/data/models/venue.dart';
import 'package:wolt_flutter_assignment/features/venues/data/datasources/venue_api_client.dart';
import 'package:wolt_flutter_assignment/features/venues/data/repositories/venue_repository.dart';

class MockVenueApiClient extends Mock implements VenueApiClient {}

class MockImage extends Mock implements ItemImage {}

class MockVenue extends Mock implements ItemVenue {}

void main() {
  final getIt = GetIt.instance;

  setUpAll(() {
    getIt.registerLazySingleton<VenueApiClient>(() => MockVenueApiClient());
  });

  tearDownAll(() {
    getIt.reset();
  });

  group('VenueRepositoryImpl', () {
    late MockVenueApiClient mockVenueApiClient;
    late VenueRepositoryImpl venueRepository;

    setUp(() {
      mockVenueApiClient = getIt<VenueApiClient>() as MockVenueApiClient;
      venueRepository = VenueRepositoryImpl();
    });

    test('getNearbyVenues returns list of venues when the call completes successfully', () async {
      final location = PhoneLocation(latitude: 37.7749, longitude: -122.4194);
      final mockItems = [
        Item(image: MockImage(), venue: MockVenue()),
        Item(image: MockImage(), venue: MockVenue())
      ];

      when(() => mockVenueApiClient.getVenuesByLocation(location.latitude, location.longitude))
          .thenAnswer((_) async => mockItems);

      final venues = await venueRepository.getNearbyVenues(location);

      expect(venues, isA<List<Venue>>());
      expect(venues.length, mockItems.length);
    });

    test('getNearbyVenues returns empty list when no items are found', () async {
      final location = PhoneLocation(latitude: 37.7749, longitude: -122.4194);

      when(() => mockVenueApiClient.getVenuesByLocation(location.latitude, location.longitude))
          .thenAnswer((_) async => []);

      final venues = await venueRepository.getNearbyVenues(location);

      expect(venues, isEmpty);
    });

  });
}