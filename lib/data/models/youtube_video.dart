class YouTubeVideo {
  final String kind;
  final String etag;
  final String id;
  final String rating; // e.g., "like", "dislike", "none"
  final VideoSnippet snippet;
  final ContentDetails contentDetails;
  final VideoStatus status;
  final Statistics statistics;
  final TopicDetails? topicDetails;

  YouTubeVideo({
    required this.kind,
    required this.etag,
    required this.id,
    required this.rating,
    required this.snippet,
    required this.contentDetails,
    required this.status,
    required this.statistics,
    this.topicDetails,
  });

  factory YouTubeVideo.fromJson(Map<String, dynamic> json) {
    return YouTubeVideo(
      kind: json['kind'] ?? '',
      etag: json['etag'] ?? '',
      id: json['id'] ?? '',
      rating: json['rating'] ?? 'none', // Optional: default 'none'
      snippet: VideoSnippet.fromJson(json['snippet'] ?? {}),
      contentDetails: ContentDetails.fromJson(json['contentDetails'] ?? {}),
      status: VideoStatus.fromJson(json['status'] ?? {}),
      statistics: Statistics.fromJson(json['statistics'] ?? {}),
      topicDetails: json['topicDetails'] != null
          ? TopicDetails.fromJson(json['topicDetails'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kind': kind,
      'etag': etag,
      'id': id,
      'rating': rating,
      'snippet': snippet.toJson(),
      'contentDetails': contentDetails.toJson(),
      'status': status.toJson(),
      'statistics': statistics.toJson(),
      if (topicDetails != null) 'topicDetails': topicDetails!.toJson(),
    };
  }

  // Add getter methods for convenience
  String get title => snippet.title;
  String get description => snippet.description;
  String get channelTitle => snippet.channelTitle;
}


class VideoSnippet {
  final String publishedAt;
  final String channelId;
  final String title;
  final String description;
  final Thumbnails thumbnails;
  final String channelTitle;
  final List<String> tags;
  final String categoryId;
  final String liveBroadcastContent;
  final Localized localized;
  final String? defaultAudioLanguage;

  VideoSnippet({
    required this.publishedAt,
    required this.channelId,
    required this.title,
    required this.description,
    required this.thumbnails,
    required this.channelTitle,
    required this.tags,
    required this.categoryId,
    required this.liveBroadcastContent,
    required this.localized,
    this.defaultAudioLanguage,
  });

  factory VideoSnippet.fromJson(Map<String, dynamic> json) {
    return VideoSnippet(
      publishedAt: json['publishedAt'] ?? '',
      channelId: json['channelId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnails: Thumbnails.fromJson(json['thumbnails'] ?? {}),
      channelTitle: json['channelTitle'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      categoryId: json['categoryId'] ?? '',
      liveBroadcastContent: json['liveBroadcastContent'] ?? '',
      localized: Localized.fromJson(json['localized'] ?? {}),
      defaultAudioLanguage: json['defaultAudioLanguage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'publishedAt': publishedAt,
      'channelId': channelId,
      'title': title,
      'description': description,
      'thumbnails': thumbnails.toJson(),
      'channelTitle': channelTitle,
      'tags': tags,
      'categoryId': categoryId,
      'liveBroadcastContent': liveBroadcastContent,
      'localized': localized.toJson(),
      if (defaultAudioLanguage != null) 'defaultAudioLanguage': defaultAudioLanguage,
    };
  }
}

class Thumbnails {
  final ThumbnailDetail? defaultThumbnail;
  final ThumbnailDetail? medium;
  final ThumbnailDetail? high;
  final ThumbnailDetail? standard;
  final ThumbnailDetail? maxres;

  Thumbnails({
    this.defaultThumbnail,
    this.medium,
    this.high,
    this.standard,
    this.maxres,
  });

  factory Thumbnails.fromJson(Map<String, dynamic> json) {
    return Thumbnails(
      defaultThumbnail: json['default'] != null
          ? ThumbnailDetail.fromJson(json['default'])
          : null,
      medium:
          json['medium'] != null ? ThumbnailDetail.fromJson(json['medium']) : null,
      high: json['high'] != null ? ThumbnailDetail.fromJson(json['high']) : null,
      standard: json['standard'] != null
          ? ThumbnailDetail.fromJson(json['standard'])
          : null,
      maxres:
          json['maxres'] != null ? ThumbnailDetail.fromJson(json['maxres']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (defaultThumbnail != null) 'default': defaultThumbnail!.toJson(),
      if (medium != null) 'medium': medium!.toJson(),
      if (high != null) 'high': high!.toJson(),
      if (standard != null) 'standard': standard!.toJson(),
      if (maxres != null) 'maxres': maxres!.toJson(),
    };
  }
}

class ThumbnailDetail {
  final String url;
  final int width;
  final int height;

  ThumbnailDetail({
    required this.url,
    required this.width,
    required this.height,
  });

  factory ThumbnailDetail.fromJson(Map<String, dynamic> json) {
    return ThumbnailDetail(
      url: json['url'] ?? '',
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'width': width,
      'height': height,
    };
  }
}

class Localized {
  final String title;
  final String description;

  Localized({
    required this.title,
    required this.description,
  });

  factory Localized.fromJson(Map<String, dynamic> json) {
    return Localized(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }
}

class ContentDetails {
  final String duration;
  final String dimension;
  final String definition;
  final String caption;
  final bool licensedContent;
  final Map<String, dynamic> contentRating;
  final String projection;

  ContentDetails({
    required this.duration,
    required this.dimension,
    required this.definition,
    required this.caption,
    required this.licensedContent,
    required this.contentRating,
    required this.projection,
  });

  factory ContentDetails.fromJson(Map<String, dynamic> json) {
    return ContentDetails(
      duration: json['duration'] ?? '',
      dimension: json['dimension'] ?? '',
      definition: json['definition'] ?? '',
      caption: json['caption'] ?? '',
      licensedContent: json['licensedContent'] ?? false,
      contentRating: json['contentRating'] ?? {},
      projection: json['projection'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'duration': duration,
      'dimension': dimension,
      'definition': definition,
      'caption': caption,
      'licensedContent': licensedContent,
      'contentRating': contentRating,
      'projection': projection,
    };
  }
}

class VideoStatus {
  final String uploadStatus;
  final String privacyStatus;
  final String license;
  final bool embeddable;
  final bool publicStatsViewable;
  final bool madeForKids;

  VideoStatus({
    required this.uploadStatus,
    required this.privacyStatus,
    required this.license,
    required this.embeddable,
    required this.publicStatsViewable,
    required this.madeForKids,
  });

  factory VideoStatus.fromJson(Map<String, dynamic> json) {
    return VideoStatus(
      uploadStatus: json['uploadStatus'] ?? '',
      privacyStatus: json['privacyStatus'] ?? '',
      license: json['license'] ?? '',
      embeddable: json['embeddable'] ?? false,
      publicStatsViewable: json['publicStatsViewable'] ?? false,
      madeForKids: json['madeForKids'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uploadStatus': uploadStatus,
      'privacyStatus': privacyStatus,
      'license': license,
      'embeddable': embeddable,
      'publicStatsViewable': publicStatsViewable,
      'madeForKids': madeForKids,
    };
  }
}

class Statistics {
  final String viewCount;
  final String likeCount;
  final String favoriteCount;
  final String commentCount;

  Statistics({
    required this.viewCount,
    required this.likeCount,
    required this.favoriteCount,
    required this.commentCount,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      viewCount: json['viewCount'] ?? '0',
      likeCount: json['likeCount'] ?? '0',
      favoriteCount: json['favoriteCount'] ?? '0',
      commentCount: json['commentCount'] ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'viewCount': viewCount,
      'likeCount': likeCount,
      'favoriteCount': favoriteCount,
      'commentCount': commentCount,
    };
  }
}

class TopicDetails {
  final List<String> topicCategories;

  TopicDetails({
    required this.topicCategories,
  });

  factory TopicDetails.fromJson(Map<String, dynamic> json) {
    return TopicDetails(
      topicCategories: List<String>.from(json['topicCategories'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topicCategories': topicCategories,
    };
  }
}

enum VideoRating {
  like,
  dislike,
  none;

  String toJson() => name;
} 