class YouTubeChannel {
  final String kind;
  final String etag;
  final String id;
  final ChannelSnippet snippet;
  final ContentDetails contentDetails;
  final Statistics statistics;
  final ChannelStatus status;

  YouTubeChannel({
    required this.kind,
    required this.etag,
    required this.id,
    required this.snippet,
    required this.contentDetails,
    required this.statistics,
    required this.status,
  });

  factory YouTubeChannel.fromJson(Map<String, dynamic> json) {
    return YouTubeChannel(
      kind: json['kind'] ?? '',
      etag: json['etag'] ?? '',
      id: json['id'] ?? '',
      snippet: ChannelSnippet.fromJson(json['snippet'] ?? {}),
      contentDetails: ContentDetails.fromJson(json['contentDetails'] ?? {}),
      statistics: Statistics.fromJson(json['statistics'] ?? {}),
      status: ChannelStatus.fromJson(json['status'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kind': kind,
      'etag': etag,
      'id': id,
      'snippet': snippet.toJson(),
      'contentDetails': contentDetails.toJson(),
      'statistics': statistics.toJson(),
      'status': status.toJson(),
    };
  }
}

class ChannelSnippet {
  final String title;
  final String description;
  final String customUrl;
  final String publishedAt;
  final Thumbnails thumbnails;
  final Localized localized;

  ChannelSnippet({
    required this.title,
    required this.description,
    required this.customUrl,
    required this.publishedAt,
    required this.thumbnails,
    required this.localized,
  });

  factory ChannelSnippet.fromJson(Map<String, dynamic> json) {
    return ChannelSnippet(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      customUrl: json['customUrl'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      thumbnails: Thumbnails.fromJson(json['thumbnails'] ?? {}),
      localized: Localized.fromJson(json['localized'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'customUrl': customUrl,
      'publishedAt': publishedAt,
      'thumbnails': thumbnails.toJson(),
      'localized': localized.toJson(),
    };
  }
}

class Thumbnails {
  final ThumbnailDetail? defaultThumbnail;
  final ThumbnailDetail? medium;
  final ThumbnailDetail? high;

  Thumbnails({
    this.defaultThumbnail,
    this.medium,
    this.high,
  });

  factory Thumbnails.fromJson(Map<String, dynamic> json) {
    return Thumbnails(
      defaultThumbnail: json['default'] != null ? ThumbnailDetail.fromJson(json['default']) : null,
      medium: json['medium'] != null ? ThumbnailDetail.fromJson(json['medium']) : null,
      high: json['high'] != null ? ThumbnailDetail.fromJson(json['high']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'default': defaultThumbnail?.toJson(),
      'medium': medium?.toJson(),
      'high': high?.toJson(),
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
  final RelatedPlaylists relatedPlaylists;

  ContentDetails({
    required this.relatedPlaylists,
  });

  factory ContentDetails.fromJson(Map<String, dynamic> json) {
    return ContentDetails(
      relatedPlaylists: RelatedPlaylists.fromJson(json['relatedPlaylists'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'relatedPlaylists': relatedPlaylists.toJson(),
    };
  }
}

class RelatedPlaylists {
  final String likes;
  final String uploads;

  RelatedPlaylists({
    required this.likes,
    required this.uploads,
  });

  factory RelatedPlaylists.fromJson(Map<String, dynamic> json) {
    return RelatedPlaylists(
      likes: json['likes'] ?? '',
      uploads: json['uploads'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'likes': likes,
      'uploads': uploads,
    };
  }
}

class Statistics {
  final String viewCount;
  final String subscriberCount;
  final bool hiddenSubscriberCount;
  final String videoCount;

  Statistics({
    required this.viewCount,
    required this.subscriberCount,
    required this.hiddenSubscriberCount,
    required this.videoCount,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      viewCount: json['viewCount'] ?? '0',
      subscriberCount: json['subscriberCount'] ?? '0',
      hiddenSubscriberCount: json['hiddenSubscriberCount'] ?? false,
      videoCount: json['videoCount'] ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'viewCount': viewCount,
      'subscriberCount': subscriberCount,
      'hiddenSubscriberCount': hiddenSubscriberCount,
      'videoCount': videoCount,
    };
  }
}

class ChannelStatus {
  final String privacyStatus;
  final bool isLinked;
  final String longUploadsStatus;

  ChannelStatus({
    required this.privacyStatus,
    required this.isLinked,
    required this.longUploadsStatus,
  });

  factory ChannelStatus.fromJson(Map<String, dynamic> json) {
    return ChannelStatus(
      privacyStatus: json['privacyStatus'] ?? '',
      isLinked: json['isLinked'] ?? false,
      longUploadsStatus: json['longUploadsStatus'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'privacyStatus': privacyStatus,
      'isLinked': isLinked,
      'longUploadsStatus': longUploadsStatus,
    };
  }
} 