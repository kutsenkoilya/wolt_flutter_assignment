import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wolt_flutter_assignment/features/venues/presentation/widgets/venue_tile.dart';

void main() {
  testWidgets('VenueTile displays venue information correctly', (WidgetTester tester) async {
    const id = '1';
    const imageUrl = 'https://example.com/image.jpg';
    const title = 'Venue Title';
    const description = 'Venue Description';
    const isLiked = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VenueTile(
            id: id,
            imageUrl: imageUrl,
            title: title,
            description: description,
            isFavorite: isLiked,
            onToggleFavorite: () {},
          ),
        ),
      ),
    );

    expect(find.text(title), findsOneWidget);
    expect(find.text(description), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
  });

  testWidgets('VenueTile displays liked state correctly', (WidgetTester tester) async {
    const id = '1';
    const imageUrl = 'https://example.com/image.jpg';
    const title = 'Venue Title';
    const description = 'Venue Description';
    const isLiked = true;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VenueTile(
            id: id,
            imageUrl: imageUrl,
            title: title,
            description: description,
            isFavorite: isLiked,
            onToggleFavorite: () {},
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });

  testWidgets('VenueTile calls onToggleLike when favorite button is pressed', (WidgetTester tester) async {
    const id = '1';
    const imageUrl = 'https://example.com/image.jpg';
    const title = 'Venue Title';
    const description = 'Venue Description';
    const isLiked = false;
    bool isLikedState = isLiked;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: VenueTile(
            id: id,
            imageUrl: imageUrl,
            title: title,
            description: description,
            isFavorite: isLikedState,
            onToggleFavorite: () {
              isLikedState = !isLikedState;
            },
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);

    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pumpAndSettle();

    expect(isLikedState, isTrue);
  });
}