import 'package:get_it/get_it.dart';
import '../location/data/models/phone_location.dart';
import 'data/models/venue.dart';
import 'data/repositories/favorites_repository.dart';
import 'data/repositories/venue_repository.dart';

abstract class VenueProvider {
  final int _venueLimit;

  VenueProvider(this._venueLimit);

  Future<List<Venue>> getNearbyVenues(PhoneLocation location);
  Future manageFavorites(String id, bool isAdd);
}

class VenueProviderImpl implements VenueProvider {
  @override
  final int _venueLimit;
  final FavoriteVenuesRepository _favoriteVenuesRepository = GetIt.I<FavoriteVenuesRepository>();
  final VenueRepository _venueRepository = GetIt.I<VenueRepository>();

  @override
  VenueProviderImpl({required int venueLimit})
      : _venueLimit = venueLimit;

  @override
  Future<List<Venue>> getNearbyVenues(PhoneLocation location) async {
    final response = await _venueRepository.getNearbyVenues(location);
    final favoriteIds = await _favoriteVenuesRepository.getFavoriteVenueIds();
    return response.take(_venueLimit).map((venue) {
      return Venue(
        id: venue.id,
        url: venue.url,
        name: venue.name,
        description: venue.description,
        isFavorite: favoriteIds.contains(venue.id),
      );
    }).toList();
  }

  @override
  Future manageFavorites(String id, bool isAdd) async {
    if (isAdd)
    {
      await _favoriteVenuesRepository.addFavoriteVenue(id);
    }
    else
    {
      await _favoriteVenuesRepository.removeFavoriteVenue(id);
    }
  }
}