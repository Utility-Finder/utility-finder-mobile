// Utility model
class Utility {
  final String id;
  final int type;
  final String imageURL;
  final double lat;
  final double lon;
  final String description;
  final double rating;

  Utility({
    this.id,
    this.type,
    this.imageURL,
    this.lat,
    this.lon,
    this.description,
    this.rating,
  });

  factory Utility.fromJson(Map<String, dynamic> json) {
    return Utility(
      id: json['id'],
      type: json['type'],
      imageURL: json['imageURL'],
      lat: double.parse(json['lat'].toString()),
      lon: double.parse(json['lon'].toString()),
      description: json['description'],
      rating: double.parse(json['rating'].toString()),
    );
  }
}
