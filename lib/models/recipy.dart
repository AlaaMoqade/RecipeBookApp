import 'dart:convert';

class Recipe {
  final int? id;
  final String name;
  final String image;
  final double rating;
  final List<String> ingredients;
  final List<String> instructions;
  final String
  userEmail; // لازم لانو بدي اعرف الايمل لمين عشان احفظ الوصفة بحسابو *_*

  Recipe({
    this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.ingredients,
    required this.instructions,
    required this.userEmail,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    id: json['id'],
    name: json['name'],
    image: json['image'],
    rating: (json['rating'] as num).toDouble(),
    ingredients: List<String>.from(json['ingredients']),
    instructions: List<String>.from(json['instructions']),
    userEmail: json['userEmail'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image': image,
    'rating': rating,
    'ingredients': ingredients,
    'instructions': instructions,
    'userEmail': userEmail,
  };

  Map<String, dynamic> toMap(dynamic r) => {
    'id': id,
    'name': name,
    'image': image,
    'rating': rating,
    'ingredients': jsonEncode(r.ingredients),
    'instructions': jsonEncode(r.instructions),
    'userEmail': userEmail,
  };

  factory Recipe.fromMap(Map<String, dynamic> map) => Recipe(
    id: map['id'],
    name: map['name'],
    image: map['image'],
    rating: map['rating'],
    ingredients: List<String>.from(jsonDecode(map['ingredients'])),
    instructions: List<String>.from(jsonDecode(map['instructions'])),
    userEmail: map['userEmail'],
  );
}
