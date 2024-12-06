import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:wolt_flutter_assignment/services/logger_service.dart';
import 'package:wolt_flutter_assignment/services/wolt_api_client.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  final getIt = GetIt.instance;

  setUpAll(() {
    getIt.registerLazySingleton<LoggerService>(() => LoggerService('TestLogger'));
    getIt.registerLazySingleton<http.Client>(() => MockHttpClient());
  });

  tearDownAll(() {
    getIt.reset();
  });

  group('WoltApiClientImpl', () {
    late MockHttpClient mockClient;
    late WoltApiClientImpl apiClient;

    setUp(() {
      mockClient = getIt<http.Client>() as MockHttpClient;
      apiClient = WoltApiClientImpl(baseUrl: 'https://restaurant-api.wolt.com/v1');
    });

    test('get method returns response when the call completes successfully', () async {
      const endpoint = 'test-endpoint';
      final uri = Uri.parse('https://restaurant-api.wolt.com/v1/$endpoint');
      final response = http.Response('{"data": "test"}', 200);
      when(() => mockClient.get(uri)).thenAnswer((_) async => response);

      final result = await apiClient.get(endpoint);

      expect(result.statusCode, 200);
      expect(result.body, '{"data": "test"}');
    });

    test('get method throws an exception when the call completes with an error', () async {
      const endpoint = 'test-endpoint';
      final uri = Uri.parse('https://restaurant-api.wolt.com/v1/$endpoint');
      final response = http.Response('Not Found', 404);
      when(() => mockClient.get(uri)).thenAnswer((_) async => response);

      expect(() => apiClient.get(endpoint), throwsException);
    });

    test('get method correctly handles query parameters', () async {
      const endpoint = 'test-endpoint';
      final queryParameters = {'key1': 'value1', 'key2': 'value2'};
      final uri = Uri.parse('https://restaurant-api.wolt.com/v1/$endpoint').replace(queryParameters: queryParameters);
      final response = http.Response('{"data": "test"}', 200);
      when(() => mockClient.get(uri)).thenAnswer((_) async => response);

      final result = await apiClient.get(endpoint, queryParameters: queryParameters);

      expect(result.statusCode, 200);
      expect(result.body, '{"data": "test"}');
    });
  });
}