class YouTubeVideo {
  final String id;
  final String? title;
  final String? description;
  final String? rating;

  YouTubeVideo({
    required this.id,
    this.title,
    this.description,
    this.rating,
  });

  factory YouTubeVideo.fromJson(Map<String, dynamic> json) {
    return YouTubeVideo(
      id: json['id'] ?? '',
      title: json['title'],
      description: json['description'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (rating != null) 'rating': rating,
    };
  }
}

enum VideoRating {
  like,
  dislike,
  none;

  String toJson() => name;
} 