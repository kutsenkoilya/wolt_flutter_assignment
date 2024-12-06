import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wolt_flutter_assignment/features/venues/presentation/widgets/venue_error.dart';

void main() {
  testWidgets('VenueError displays the error message', (WidgetTester tester) async {
    const errorMessage = 'An error occurred';

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: VenueError(message: errorMessage),
        ),
      ),
    );

    expect(find.text(errorMessage), findsOneWidget);

    final textWidget = tester.widget<Text>(find.text(errorMessage));
    expect(textWidget.textAlign, TextAlign.center);

    expect(textWidget.style?.fontSize, 18.0);
  });
}