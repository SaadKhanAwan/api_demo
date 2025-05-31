import 'package:api_integration/data/models/youtube_video.dart';

class YouTubeVideoResponse {
  final List<YouTubeVideo> items;
  final String nextPageToken;
  final String prevPageToken;
  final PageInfo pageInfo;

  YouTubeVideoResponse({
    required this.items,
    required this.nextPageToken,
    required this.prevPageToken,
    required this.pageInfo,
  });

  factory YouTubeVideoResponse.fromJson(Map<String, dynamic> json) {
    return YouTubeVideoResponse(
      items: (json['items'] as List?)?.map((item) => YouTubeVideo.fromJson(item)).toList() ?? [],
      nextPageToken: json['nextPageToken'] ?? '',
      prevPageToken: json['prevPageToken'] ?? '',
      pageInfo: PageInfo.fromJson(json['pageInfo'] ?? {}),
    );
  }
}

class PageInfo {
  final int totalResults;
  final int resultsPerPage;

  PageInfo({
    required this.totalResults,
    required this.resultsPerPage,
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) {
    return PageInfo(
      totalResults: json['totalResults'] ?? 0,
      resultsPerPage: json['resultsPerPage'] ?? 0,
    );
  }
} 