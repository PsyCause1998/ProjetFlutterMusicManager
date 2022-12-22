class RadioModel {
  late int id;
  late String name;
  late String url;
  late String image;
  RadioModel(
      {required this.id,
      required this.name,
      required this.url,
      required this.image});

  static fromJson(radio) {
    return RadioModel(
      id: radio['id'],
      name: radio['name'],
      url: radio['url'],
      image: radio['img'],
    );
  }
}
