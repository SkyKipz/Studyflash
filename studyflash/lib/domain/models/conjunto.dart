class Conjunto {
  final String id;
  final String title;
  final String description;

  Conjunto({
    required this.id,
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
    };
  }

  factory Conjunto.fromMap(String id, Map data) {
    return Conjunto(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
    );
  }
}
