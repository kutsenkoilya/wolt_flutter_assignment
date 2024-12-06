import 'package:get_it/get_it.dart';
import 'package:wolt_flutter_assignment/features/location/data/models/phone_location.dart';
import 'package:wolt_flutter_assignment/features/venues/data/models/venue.dart';
import 'package:wolt_flutter_assignment/features/venues/data/datasources/venue_api_client.dart';

abstract class VenueRepository {
  Future<List<Venue>> getNearbyVenues(PhoneLocation location);
}

class VenueRepositoryImpl implements VenueRepository {
  final VenueApiClient _venueApiClient = GetIt.I<VenueApiClient>();

  @override
  Future<List<Venue>> getNearbyVenues(PhoneLocation location) async {
    var items = await _venueApiClient.getVenuesByLocation(location.latitude, location.longitude);
    if (items == null)
    {
      return [];
    }

    return items.where((item) => item.image != null && item.venue != null).map((item) {
      return Venue(
        id: item.venue!.id ?? '0',
        url: item.image!.url ?? 'assets/default_image.png',
        name: item.venue!.name ?? 'Unknown Venue',
        description: item.venue!.shortDescription ?? 'No description available',
      );
    }).toList();
  }
}