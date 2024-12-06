class ItemImage {
  final String? url;

  ItemImage({this.url});

  factory ItemImage.fromJson(Map<String, dynamic> json) {
    return ItemImage(
      url: json['url'],
    );
  }
}