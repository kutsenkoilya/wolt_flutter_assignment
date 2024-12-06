import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wolt_flutter_assignment/di.dart';
import 'package:wolt_flutter_assignment/features/venues/presentation/screens/venue_screen.dart';
import 'package:flutter/foundation.dart';

void main() async {
  var configPath = "assets/config/.env.dev";
  if (kReleaseMode) {
    configPath = "assets/config/.env.prod";
  }
  await dotenv.load(fileName: configPath);

  await setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const VenueScreen(),
        }
    );
  }
}