import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:location/location.dart';
import 'dart:async';

abstract class LocationService {
  final int _locationUpdateSeconds;

  LocationService(this._locationUpdateSeconds);
  
  Stream<LocationData> get onLocationChanged;
}

class LocationServiceImpl implements LocationService {
  @override
  final int _locationUpdateSeconds;
  final Location _location = Location();

  @override
  LocationServiceImpl({required int locationUpdateSeconds})
      : _locationUpdateSeconds = locationUpdateSeconds;

  @override
  Stream<LocationData> get onLocationChanged => _location.onLocationChanged;
}

class MockLocationServiceImpl implements LocationService {
  @override
  final int _locationUpdateSeconds;

  @override
  MockLocationServiceImpl({required int locationUpdateSeconds})
      : _locationUpdateSeconds = locationUpdateSeconds;

  Future<List<Map<String, double>>> _loadLocationsFromAssets() async {
    final jsonString = await rootBundle.loadString('assets/mock/locations.json');
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((item) => {
      'latitude': item['latitude'] as double,
      'longitude': item['longitude'] as double,
    }).toList().cast<Map<String, double>>();
  }

  @override
  Stream<LocationData> get onLocationChanged async* {
    final locations = await _loadLocationsFromAssets();
    int index = 0;
    while (true) {
      final locationData = LocationData.fromMap({
        'latitude': locations[index]['latitude']  as double,
        'longitude': locations[index]['longitude']  as double,
        'accuracy': 10.0,
        'altitude': 30.0,
        'speed': 0.0,
        'heading': 0.0,
        'isMock' : true
      });

      yield locationData;
      index = (index + 1) % locations.length;

      await Future.delayed(Duration(seconds: _locationUpdateSeconds));
    }
  }
}
