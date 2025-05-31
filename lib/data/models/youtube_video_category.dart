class YouTubeVideoCategory {
  final String kind;
  final String etag;
  final String id;
  final VideoCategorySnippet snippet;

  YouTubeVideoCategory({
    required this.kind,
    required this.etag,
    required this.id,
    required this.snippet,
  });

  factory YouTubeVideoCategory.fromJson(Map<String, dynamic> json) {
    return YouTubeVideoCategory(
      kind: json['kind'] ?? '',
      etag: json['etag'] ?? '',
      id: json['id'] ?? '',
      snippet: VideoCategorySnippet.fromJson(json['snippet'] ?? {}),
    );
  }
}

class VideoCategorySnippet {
  final String title;
  final bool assignable;
  final String channelId;

  VideoCategorySnippet({
    required this.title,
    required this.assignable,
    required this.channelId,
  });

  factory VideoCategorySnippet.fromJson(Map<String, dynamic> json) {
    return VideoCategorySnippet(
      title: json['title'] ?? '',
      assignable: json['assignable'] ?? false,
      channelId: json['channelId'] ?? '',
    );
  }
}

class YouTubeVideoCategoryResponse {
  final String code;
  final String msg;
  final List<YouTubeVideoCategory> items;

  YouTubeVideoCategoryResponse({
    required this.code,
    required this.msg,
    required this.items,
  });

  factory YouTubeVideoCategoryResponse.fromJson(Map<String, dynamic> json) {
    return YouTubeVideoCategoryResponse(
      code: json['code']?.toString() ?? '',
      msg: json['msg'] ?? '',
      items: (json['items'] as List?)
              ?.map((item) => YouTubeVideoCategory.fromJson(item))
              .toList() ??
          [],
    );
  }
} 