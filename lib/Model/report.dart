class Report{
  final String id;
  final String avatar;
  final String username;
  final String content;
  final DateTime createdAt;

  const Report({
    required this.id,
    required this.avatar,
    required this.username,
    required this.content,
    required this.createdAt
  });
}