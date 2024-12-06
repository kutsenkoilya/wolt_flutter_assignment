import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wolt_flutter_assignment/features/venues/data/models/venue.dart';
import 'package:wolt_flutter_assignment/features/venues/presentation/widgets/venue_list.dart';

void main() {
  testWidgets('VenueList displays a list of venues', (WidgetTester tester) async {
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
    void onManageFavorites(String id, bool isFavorite) async {}

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VenueList(venues: venues, onManageFavorites: onManageFavorites,),
        ),
      ),
    );

    for (var venue in venues) {
      expect(find.text(venue.name), findsOneWidget);
      expect(find.text(venue.description), findsOneWidget);
    }
  });

  testWidgets('VenueList handles favorite button toggle', (WidgetTester tester) async {
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
    void onManageFavorites(String id, bool isFavorite) async {}

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VenueList(venues: venues, onManageFavorites: onManageFavorites,),
        ),
      ),
    );

    // Verify initial favorite states
    for (var venue in venues) {
      if (venue.isFavorite) {
        expect(find.byIcon(Icons.favorite), findsWidgets);
      } else {
        expect(find.byIcon(Icons.favorite_border), findsWidgets);
      }
    }

    await tester.tap(find.byIcon(Icons.favorite_border).first);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite).first, findsOneWidget);
  });
}