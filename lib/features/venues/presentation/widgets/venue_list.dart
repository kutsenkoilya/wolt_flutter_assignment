import 'package:flutter/material.dart';
import 'package:wolt_flutter_assignment/features/venues/data/models/venue.dart';
import 'venue_tile.dart';

class VenueList extends StatefulWidget {
  final List<Venue> venues;
  final void Function(String id, bool isFavorite) onManageFavorites;

  const VenueList({super.key, required this.venues, required this.onManageFavorites});

  @override
  State<VenueList> createState() => _VenueListState();
}

class _VenueListState extends State<VenueList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  void _toggleFavorite(String id) async {
    var index = widget.venues.indexWhere((x) => x.id == id);
    var isFavorite = widget.venues[index].isFavorite;

    setState(() {
      widget.venues[index].isFavorite = !isFavorite;
      widget.onManageFavorites(id, isFavorite);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      initialItemCount: widget.venues.length,
      itemBuilder: (context, index, animation) {
        final venue = widget.venues[index];
        return SizeTransition(
          sizeFactor: animation,
          child: VenueTile(
            id: venue.id,
            imageUrl: venue.url,
            title: venue.name,
            description: venue.description,
            isFavorite: venue.isFavorite,
            onToggleFavorite: () => _toggleFavorite(venue.id),
          ),
        );
      },
    );
  }
}