import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:location/location.dart';
import 'package:wolt_flutter_assignment/features/location/data/models/phone_location.dart';
import 'package:wolt_flutter_assignment/features/location/locaiton_service.dart';
import 'package:wolt_flutter_assignment/features/venues/data/models/venue.dart';
import 'package:wolt_flutter_assignment/features/venues/presentation/widgets/venue_list.dart';
import 'package:wolt_flutter_assignment/features/venues/venue_provider.dart';
import '../widgets/venue_error.dart';

class VenueScreen extends StatefulWidget {
  const VenueScreen({super.key});

  @override
  State<VenueScreen> createState() => _VenueScreenState();
}

class _VenueScreenState extends State<VenueScreen> {
  final VenueProvider _venueProvider = GetIt.I<VenueProvider>();
  final LocationService _locationService = GetIt.I<LocationService>();

  void _onManageFavorites(String id, bool isFavorite) async {
    await _venueProvider.manageFavorites(id, !isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Venue List')),
      body: StreamBuilder<LocationData>(
        stream: _locationService.onLocationChanged,
        builder: (context, locationSnapshot) {
          if (locationSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (locationSnapshot.hasError) {
            return VenueError(message: '${locationSnapshot.error}');
          } else if (!locationSnapshot.hasData) {
            return const VenueError(message: 'No location data available');
          } else {
            final locationData = locationSnapshot.data!;
            return FutureBuilder<List<Venue>>(
              future: _venueProvider.getNearbyVenues(
                PhoneLocation(
                  latitude: locationData.latitude!,
                  longitude: locationData.longitude!,
                ),
              ),
              builder: (context, venueSnapshot) {
                if (venueSnapshot.hasError) {
                  return VenueError(message: '${venueSnapshot.error}');
                } else if (!venueSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else if (venueSnapshot.data!.isEmpty) {
                  return const VenueError(message: 'No venues found');
                } else {
                  return VenueList(
                    venues: venueSnapshot.data!,
                    onManageFavorites: _onManageFavorites,
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}