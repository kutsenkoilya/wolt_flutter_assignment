import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../di.dart';
import 'logger_service.dart';

abstract class WoltApiClient {
  final String _baseUrl;

  WoltApiClient(this._baseUrl);

  Future<http.Response> get(String endpoint, {Map<String, String>? queryParameters});
}

class WoltApiClientImpl implements WoltApiClient {
  @override
  final String _baseUrl;

  final LoggerService _logger = GetIt.I<LoggerService>();
  final _httpClient = getIt<http.Client>();

  @override
  WoltApiClientImpl({required String baseUrl})
      : _baseUrl = baseUrl;

  @override
  Future<http.Response> get(String endpoint, {Map<String, String>? queryParameters}) async {
      final uri = Uri.parse('$_baseUrl/$endpoint').replace(
        queryParameters: queryParameters?.map((key, value) =>
            MapEntry(key, value.toString())),);
      final response = await _httpClient.get(uri);

      if (response.statusCode == 200) {
        return response;
      } else {
        const failedToGet = 'Failed to perform GET request';
        _logger.error(failedToGet);
        throw Exception(failedToGet);
      }
  }
}