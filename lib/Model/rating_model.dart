class RatingModel{
  final String id;
  final String avatar;
  final String username;
  final double rating;
  final String content;
  final DateTime createdAt;

  const RatingModel({
    required this.id,
    required this.avatar,
    required this.username,
    required this.rating,
    required this.content,
    required this.createdAt
  });
}