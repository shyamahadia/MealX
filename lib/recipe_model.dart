class Recipe {
  final int id;
  final String title;
  final String imageUrl;
  //final double calories;

  Recipe({required this.id, required this.title, required this.imageUrl,
    //required this.calories,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      title: json['title'],
      imageUrl: json['image'],
    //  calories: json['calories'],
    );
  }
}
