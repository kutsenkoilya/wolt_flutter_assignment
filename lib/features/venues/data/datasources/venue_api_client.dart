import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:wolt_flutter_assignment/features/venues/data/datasources/responses/item.dart';
import 'package:wolt_flutter_assignment/features/venues/data/datasources/responses/section.dart';
import 'package:wolt_flutter_assignment/services/wolt_api_client.dart';

import '../../../../services/logger_service.dart';

abstract class VenueApiClient {
  Future<List<Item>?> getVenuesByLocation(double latitude, double longitude);
}

class VenueApiClientImpl implements VenueApiClient {

  final WoltApiClient _woltApiClient = GetIt.I<WoltApiClient>();
  final LoggerService _logger = GetIt.I<LoggerService>();

  @override
  Future<List<Item>?> getVenuesByLocation(double latitude, double longitude) async {
    final response = await _woltApiClient.get(
      'pages/restaurants',
      queryParameters: {
        'lat': latitude.toString(),
        'lon': longitude.toString()
      },
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as Map<String, dynamic>;
      List<Section> sections = (json['sections'] as List).map((e) => Section.fromJson(e)).toList();

      for (var section in sections) {
        if (section.name == "restaurants-delivering-venues") {
          return section.items;
        }
        if (section.name == "no-location") {
          _logger.error('get venues $latitude:$longitude - no-location');
          throw Exception(section.description);
        }
        if (section.name == "no-content") {
          _logger.error('get venues $latitude:$longitude - no-content');
          throw Exception(section.description);
        }
      }
      const unknownError = 'Unknown Error';
      _logger.error('get venues $latitude:$longitude - $unknownError');
      throw Exception(unknownError);
    } else {
      const networkError = 'Network error. Failed to fetch venues';
      _logger.error('get venues $latitude:$longitude - $networkError');
      throw Exception(networkError);
    }
  }
}