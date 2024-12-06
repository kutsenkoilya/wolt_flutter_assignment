import 'package:wolt_flutter_assignment/features/venues/data/datasources/responses/item.dart';

class Section {
  final String name;
  final String? description;
  final List<Item>? items;
  
  Section({
    required this.name,
    this.description,
    this.items,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
	    description: json['description'],
	    name: json['name'],
      items: json['items'] != null ? (json['items'] as List).map((e) => Item.fromJson(e)).toList() : null,
    );
  }
}
