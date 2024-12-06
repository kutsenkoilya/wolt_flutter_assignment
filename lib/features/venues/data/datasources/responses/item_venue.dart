class ItemVenue {
  final String? id;
  final String? name;
  final String? shortDescription;
  
  ItemVenue({
    this.id,
    this.name,
    this.shortDescription,
  });

  factory ItemVenue.fromJson(Map<String, dynamic> json) {
    return ItemVenue(
      id: json['id'],
      name: json['name'],
      shortDescription: json['short_description'],
    );
  }
}
