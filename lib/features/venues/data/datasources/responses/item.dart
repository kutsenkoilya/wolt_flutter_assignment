import 'package:wolt_flutter_assignment/features/venues/data/datasources/responses/item_image.dart';
import 'package:wolt_flutter_assignment/features/venues/data/datasources/responses/item_venue.dart';

class Item {
  final ItemImage? image;
  final ItemVenue? venue;

  Item({
    this.image,
    this.venue,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      image: json['image'] != null ? ItemImage.fromJson(json['image']) : null,
      venue: json['venue'] != null ? ItemVenue.fromJson(json['venue']) : null,
    );
  }
}