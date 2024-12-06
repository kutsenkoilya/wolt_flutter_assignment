import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wolt_flutter_assignment/features/venues/data/datasources/responses/item.dart';
import 'package:wolt_flutter_assignment/services/logger_service.dart';
import 'package:wolt_flutter_assignment/services/wolt_api_client.dart';
import 'package:wolt_flutter_assignment/features/venues/data/datasources/venue_api_client.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MockWoltApiClient extends Mock implements WoltApiClient {}

void main() {
  final getIt = GetIt.instance;

  setUpAll(() {
    getIt.registerLazySingleton<LoggerService>(() => LoggerService('TestLogger'));
    getIt.registerLazySingleton<WoltApiClient>(() => MockWoltApiClient());
  });

  tearDownAll(() {
    getIt.reset();
  });

  group('VenueApiClientImpl', () {
    late MockWoltApiClient mockWoltApiClient;
    late VenueApiClientImpl venueApiClient;

    setUp(() {
      mockWoltApiClient = getIt<WoltApiClient>() as MockWoltApiClient;
      venueApiClient = VenueApiClientImpl();
    });

    test('getVenuesByLocation returns list of items when the call completes successfully', () async {
      const latitude = 37.7749;
      const longitude = -122.4194;
      final response = http.Response(
        jsonEncode({
          'sections': [
            {
              'name': 'restaurants-delivering-venues',
              'items': [
                {'venue': {'id': '1', 'name': 'Venue 1'}},
                {'venue': {'id': '2', 'name': 'Venue 2'}}
              ],
            },
          ],
        }),
        200,
      );

      when(() => mockWoltApiClient.get(
        'pages/restaurants',
        queryParameters: {
          'lat': latitude.toString(),
          'lon': longitude.toString(),
        },
      )).thenAnswer((_) async => response);

      final items = await venueApiClient.getVenuesByLocation(latitude, longitude);

      expect(items, isA<List<Item>>());
      expect(items!.length, 2);
      expect(items[0].venue!.id, '1');
      expect(items[1].venue!.id, '2');
    });

    test('getVenuesByLocation throws an exception when the call completes with an error', () async {
      const latitude = 37.7749;
      const longitude = -122.4194;
      final response = http.Response('Not Found', 404);

      when(() => mockWoltApiClient.get(
        'pages/restaurants',
        queryParameters: {
          'lat': latitude.toString(),
          'lon': longitude.toString(),
        },
      )).thenAnswer((_) async => response);

      expect(() => venueApiClient.getVenuesByLocation(latitude, longitude), throwsException);
    });

    test('getVenuesByLocation throws an exception when no location is found', () async {
      const latitude = 37.7749;
      const longitude = -122.4194;
      final response = http.Response(
        jsonEncode({
          'sections': [
            {
              'name': 'no-location',
              'description': 'No location found',
            },
          ],
        }),
        200,
      );

      when(() => mockWoltApiClient.get(
        'pages/restaurants',
        queryParameters: {
          'lat': latitude.toString(),
          'lon': longitude.toString(),
        },
      )).thenAnswer((_) async => response);

      expect(() => venueApiClient.getVenuesByLocation(latitude, longitude), throwsException);
    });

    test('getVenuesByLocation throws an exception when no content is found', () async {
      const latitude = 37.7749;
      const longitude = -122.4194;
      final response = http.Response(
        jsonEncode({
          'sections': [
            {
              'name': 'no-content',
              'description': 'No content found',
            },
          ],
        }),
        200,
      );

      when(() => mockWoltApiClient.get(
        'pages/restaurants',
        queryParameters: {
          'lat': latitude.toString(),
          'lon': longitude.toString(),
        },
      )).thenAnswer((_) async => response);

      expect(() => venueApiClient.getVenuesByLocation(latitude, longitude), throwsException);
    });
  });
}