import 'package:flutter/material.dart';

class VenueError extends StatelessWidget {
  final String message;

  const VenueError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(16.0),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}