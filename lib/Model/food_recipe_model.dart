class FoodRecipeModel{
  final String id;
  final String image;
  final String title;
  final String avatar;
  final String username;
  final String description;
  final String tag;
  final String serves;
  final String duration;
  final String ingredients;
  final String steps;
  final DateTime created;

  const FoodRecipeModel({
    required this.id,
    required this.image,
    required this.title,
    required this.avatar,
    required this.username,
    required this.description,
    required this.tag,
    required this.serves,
    required this.duration,
    required this.ingredients,
    required this.steps,
    required this.created,
  });
}