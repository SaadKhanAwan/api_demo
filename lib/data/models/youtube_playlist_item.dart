
class YouTubePlaylistItem {
  final String? id;
  final String? playlistId;
  final String title;
  final String description;
  final String? videoId;
  final String? thumbnailUrl;
  final String? publishedAt;
  final String? channelId;
  final String? channelTitle;
  final int? position;

  YouTubePlaylistItem({
    this.id,
    this.playlistId,
    required this.title,
    required this.description,
    this.videoId,
    this.thumbnailUrl,
    this.publishedAt,
    this.channelId,
    this.channelTitle,
    this.position,
  });

  factory YouTubePlaylistItem.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'] ?? {};
    final thumbnails = snippet['thumbnails'] ?? {};
    final defaultThumb = thumbnails['default'] ?? {};
    final resourceId = snippet['resourceId'] ?? {};

    return YouTubePlaylistItem(
      id: json['id'],
      playlistId: snippet['playlistId'],
      title: snippet['title'] ?? '',
      description: snippet['description'] ?? '',
      videoId: resourceId['videoId'],
      thumbnailUrl: defaultThumb['url'],
      publishedAt: snippet['publishedAt'],
      channelId: snippet['channelId'],
      channelTitle: snippet['channelTitle'],
      position: snippet['position'],
    );
  }
}

class YouTubePlaylistItemListResponse {
  final String code;
  final String msg;
  final List<YouTubePlaylistItem> items;
  final String? nextPageToken;
  final String? prevPageToken;
  final PageInfo pageInfo;

  YouTubePlaylistItemListResponse({
    required this.code,
    required this.msg,
    required this.items,
    this.nextPageToken,
    this.prevPageToken,
    required this.pageInfo,
  });

  factory YouTubePlaylistItemListResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final items = (data['items'] as List?)?.map((item) => YouTubePlaylistItem.fromJson(item)).toList() ?? [];
    
    return YouTubePlaylistItemListResponse(
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

class YouTubePlaylistItemInsertRequest {
  final String playlistId;
  final ResourceId resourceId;
  final int? position;
  final String? note;

  YouTubePlaylistItemInsertRequest({
    required this.playlistId,
    required this.resourceId,
    this.position,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'snippet': {
        'playlistId': playlistId,
        'resourceId': resourceId.toJson(),
        if (position != null) 'position': position,
      },
      if (note != null)
        'contentDetails': {
          'note': note,
        },
    };
  }
}

class ResourceId {
  final String videoId;
  final String? channelId;
  final String? kind;
  final String? playlistId;

  ResourceId({
    required this.videoId,
    this.channelId,
    this.kind,
    this.playlistId,
  });

  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      if (channelId != null) 'channelId': channelId,
      if (kind != null) 'kind': kind,
      if (playlistId != null) 'playlistId': playlistId,
    };
  }
}

class YouTubePlaylistItemUpdateRequest {
  final String id;
  final String playlistId;
  final String videoId;
  final int? position;
  final String? note;

  YouTubePlaylistItemUpdateRequest({
    required this.id,
    required this.playlistId,
    required this.videoId,
    this.position,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'snippet': {
        'playlistId': playlistId,
        'resourceId': {
          'videoId': videoId,
        },
        if (position != null) 'position': position,
      },
      if (note != null)
        'contentDetails': {
          'note': note,
        },
    };
  }
} 