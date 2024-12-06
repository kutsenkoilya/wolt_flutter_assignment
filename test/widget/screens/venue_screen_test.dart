import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:location/location.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wolt_flutter_assignment/features/location/data/models/phone_location.dart';
import 'package:wolt_flutter_assignment/features/location/locaiton_service.dart';
import 'package:wolt_flutter_assignment/features/venues/data/models/venue.dart';
import 'package:wolt_flutter_assignment/features/venues/presentation/screens/venue_screen.dart';
import 'package:wolt_flutter_assignment/features/venues/presentation/widgets/venue_list.dart';
import 'package:wolt_flutter_assignment/features/venues/presentation/widgets/venue_error.dart';
import 'package:wolt_flutter_assignment/features/venues/venue_provider.dart';

class MockVenueProvider extends Mock implements VenueProvider {}

class MockLocationService extends Mock implements LocationService {}

class MockLocationData extends Mock implements LocationData {}

void main() {
  final getIt = GetIt.instance;

  setUpAll(() {
    getIt.registerLazySingleton<VenueProvider>(() => MockVenueProvider());
    getIt.registerLazySingleton<LocationService>(() => MockLocationService());
    registerFallbackValue(PhoneLocation(latitude: 37.7749, longitude: -122.4194));
  });

  tearDownAll(() {
    getIt.reset();
  });

  group('VenueScreen', () {
    late MockVenueProvider mockVenueProvider;
    late MockLocationService mockLocationService;

    setUp(() {
      mockVenueProvider = getIt<VenueProvider>() as MockVenueProvider;
      mockLocationService = getIt<LocationService>() as MockLocationService;
    });

    Widget createWidgetUnderTest() {
      return const MaterialApp(
        home: Scaffold(
          body: VenueScreen(),
        ),
      );
    }

    testWidgets('displays loading indicator while fetching location', (WidgetTester tester) async {
      when(() => mockLocationService.onLocationChanged).thenAnswer((_) => Stream.empty());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays error message when location fetch fails', (WidgetTester tester) async {
      when(() => mockLocationService.onLocationChanged).thenAnswer((_) => Stream.error('Location error'));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(VenueError), findsOneWidget);
      expect(find.text('Location error'), findsOneWidget);
    });

    testWidgets('displays list of venues when location and venues are available', (WidgetTester tester) async {
      final mockLocationData = MockLocationData();
      final venues = List.generate(
        5,
            (index) => Venue(
          id: '$index',
          url: 'https://example.com/image$index.jpg',
          name: 'Venue $index',
          description: 'Description $index',
          isFavorite: index % 2 == 0,
        ),
      );

      when(() => mockLocationService.onLocationChanged).thenAnswer((_) => Stream.value(mockLocationData));
      when(() => mockLocationData.latitude).thenReturn(37.7749);
      when(() => mockLocationData.longitude).thenReturn(-122.4194);
      when(() => mockVenueProvider.getNearbyVenues(any())).thenAnswer((_) async => venues);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(VenueList), findsOneWidget);
      for (var venue in venues) {
        expect(find.text(venue.name), findsOneWidget);
        expect(find.text(venue.description), findsOneWidget);
      }
    });

    testWidgets('displays error message when no venues are found', (WidgetTester tester) async {
      final mockLocationData = MockLocationData();

      when(() => mockLocationService.onLocationChanged).thenAnswer((_) => Stream.value(mockLocationData));
      when(() => mockLocationData.latitude).thenReturn(37.7749);
      when(() => mockLocationData.longitude).thenReturn(-122.4194);
      when(() => mockVenueProvider.getNearbyVenues(any())).thenAnswer((_) async => []);

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(VenueError), findsOneWidget);
      expect(find.text('No venues found'), findsOneWidget);
    });
  });
}
