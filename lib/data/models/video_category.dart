class VideoCategory {
  final String id;
  final String title;
  final bool assignable;
  final String channelId;

  VideoCategory({
    required this.id,
    required this.title,
    required this.assignable,
    required this.channelId,
  });

  factory VideoCategory.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'] ?? {};
    return VideoCategory(
      id: json['id'] ?? '',
      title: snippet['title'] ?? '',
      assignable: snippet['assignable'] ?? false,
      channelId: snippet['channelId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'snippet': {
        'title': title,
        'assignable': assignable,
        'channelId': channelId,
      },
    };
  }
} 