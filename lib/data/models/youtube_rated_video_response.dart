
class YouTubeRatedVideoResponse {
  final List<RatedVideoItem> items;
  final String code;
  final String msg;
  final String url;

  YouTubeRatedVideoResponse({
    required this.items,
    required this.code,
    required this.msg,
    required this.url,
  });

  factory YouTubeRatedVideoResponse.fromJson(Map<String, dynamic> json) {
    return YouTubeRatedVideoResponse(
      items: ((json['data']?['items'] as List?) ?? [])
          .map((item) => RatedVideoItem.fromJson(item))
          .toList(),
      code: json['code']?.toString() ?? '',
      msg: json['msg'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class RatedVideoItem {
  final String videoId;
  final String rating;

  RatedVideoItem({
    required this.videoId,
    required this.rating,
  });

  factory RatedVideoItem.fromJson(Map<String, dynamic> json) {
    return RatedVideoItem(
      videoId: json['videoId'] ?? '',
      rating: json['rating'] ?? 'none',
    );
  }
} 