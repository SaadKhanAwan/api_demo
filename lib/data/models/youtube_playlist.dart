import 'dart:convert';

enum PlaylistPrivacyStatus {
  public,
  private,
  unlisted;

  String toJson() => name;
  
  static PlaylistPrivacyStatus fromJson(String value) {
    return PlaylistPrivacyStatus.values.firstWhere(
      (status) => status.name == value.toLowerCase(),
      orElse: () => PlaylistPrivacyStatus.private,
    );
  }
}

class YouTubePlaylist {
  final String? id;
  final String title;
  final String description;
  final PlaylistPrivacyStatus privacyStatus;
  final String? channelId;
  final int? itemCount;
  final String? thumbnailUrl;
  final String? publishedAt;

  YouTubePlaylist({
    this.id,
    required this.title,
    required this.description,
    required this.privacyStatus,
    this.channelId,
    this.itemCount,
    this.thumbnailUrl,
    this.publishedAt,
  });

  factory YouTubePlaylist.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'] ?? {};
    final status = json['status'] ?? {};
    final contentDetails = json['contentDetails'] ?? {};
    final thumbnails = snippet['thumbnails'] ?? {};
    final defaultThumb = thumbnails['default'] ?? {};
    
    return YouTubePlaylist(
      id: json['id'],
      title: snippet['title'] ?? '',
      description: snippet['description'] ?? '',
      privacyStatus: PlaylistPrivacyStatus.fromJson(status['privacyStatus'] ?? 'private'),
      channelId: snippet['channelId'],
      itemCount: contentDetails['itemCount'],
      thumbnailUrl: defaultThumb['url'],
      publishedAt: snippet['publishedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'snippet': {
        'title': title,
        'description': description,
        if (channelId != null) 'channelId': channelId,
        if (publishedAt != null) 'publishedAt': publishedAt,
        if (thumbnailUrl != null) 'thumbnails': {
          'default': {
            'url': thumbnailUrl,
          },
        },
      },
      'status': {
        'privacyStatus': privacyStatus.name,
      },
      'contentDetails': {
        if (itemCount != null) 'itemCount': itemCount,
      },
    };
  }
}

class YouTubePlaylistResponse {
  final String code;
  final String msg;
  final Map<String, dynamic> data;

  YouTubePlaylistResponse({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory YouTubePlaylistResponse.fromJson(Map<String, dynamic> json) {
    return YouTubePlaylistResponse(
      code: json['code']?.toString() ?? '',
      msg: json['msg'] ?? '',
      data: json['data'] as Map<String, dynamic>? ?? {},
    );
  }
}

class YouTubePlaylistListResponse {
  final String code;
  final String msg;
  final List<YouTubePlaylist> items;
  final String? nextPageToken;
  final String? prevPageToken;
  final PageInfo pageInfo;

  YouTubePlaylistListResponse({
    required this.code,
    required this.msg,
    required this.items,
    this.nextPageToken,
    this.prevPageToken,
    required this.pageInfo,
  });

  factory YouTubePlaylistListResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final items = (data['items'] as List?)?.map((item) => YouTubePlaylist.fromJson(item)).toList() ?? [];
    
    return YouTubePlaylistListResponse(
      code: json['code']?.toString() ?? '',
      msg: json['msg'] ?? '',
      items: items,
      nextPageToken: data['nextPageToken'],
      prevPageToken: data['prevPageToken'],
      pageInfo: PageInfo.fromJson(data['pageInfo'] ?? {}),
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