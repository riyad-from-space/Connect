class Properties {
  final String name;
  final String topic;
  final String heading;
  final String subheading;
  final String author;
  final int time;
  final String image;

  Properties({
    required this.name,
    required this.topic,
    required this.heading,
    required this.subheading,
    required this.author,
    required this.time,
    required this.image,
  });

  factory Properties.fromJson(Map<String, dynamic> json) {
    return Properties(
      name: json['name'],
      topic: json['topic'],
      heading: json['heading'],
      subheading: json['subheading'],
      author: json['author'],
      time: json['time'],
      image: json['image'],
    );
  }
}
