class YouTubeVideoUploadRequest {
  final String file;
  final String? title;
  final String? description;
  final List<String>? keywords;
  final String? categoryId;
  final String? privacyStatus;

  YouTubeVideoUploadRequest({
    required this.file,
    this.title,
    this.description,
    this.keywords,
    this.categoryId,
    this.privacyStatus = 'private', // Default to private for testing
  });

  Map<String, dynamic> toJson() {
    return {
      'file': file,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (keywords != null) 'keywords': keywords,
      if (categoryId != null) 'categoryId': categoryId,
      if (privacyStatus != null) 'privacyStatus': privacyStatus,
    };
  }
}

class YouTubeVideoUploadResponse {
  final String videoId;
  final String code;
  final String msg;
  final String url;

  YouTubeVideoUploadResponse({
    required this.videoId,
    required this.code,
    required this.msg,
    required this.url,
  });

  factory YouTubeVideoUploadResponse.fromJson(Map<String, dynamic> json) {
    return YouTubeVideoUploadResponse(
      videoId: json['data']?['videoId'] ?? '',
      code: json['code']?.toString() ?? '',
      msg: json['msg'] ?? '',
      url: json['url'] ?? '',
    );
  }
} 