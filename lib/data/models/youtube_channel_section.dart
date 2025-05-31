class YouTubeChannelSection {
  final String kind;
  final String etag;
  final String id;
  final String channelId;
  final String type;
  final ChannelSectionSnippet snippet;
  final ChannelSectionContentDetails? contentDetails;

  YouTubeChannelSection({
    required this.kind,
    required this.etag,
    required this.id,
    required this.channelId,
    required this.type,
    required this.snippet,
    this.contentDetails,
  });

  factory YouTubeChannelSection.fromJson(Map<String, dynamic> json) {
    return YouTubeChannelSection(
      kind: json['kind'] ?? '',
      etag: json['etag'] ?? '',
      id: json['id'] ?? '',
      channelId: json['channelId'] ?? '',
      type: json['type'] ?? '',
      snippet: ChannelSectionSnippet.fromJson(json['snippet'] ?? {}),
      contentDetails: json['contentDetails'] != null
          ? ChannelSectionContentDetails.fromJson(json['contentDetails'])
          : null,
    );
  }
}

class ChannelSectionSnippet {
  final String type;
  final String title;
  final int position;
  final String style;
  final String defaultLanguage;
  final String localized;

  ChannelSectionSnippet({
    required this.type,
    required this.title,
    required this.position,
    required this.style,
    required this.defaultLanguage,
    required this.localized,
  });

  factory ChannelSectionSnippet.fromJson(Map<String, dynamic> json) {
    return ChannelSectionSnippet(
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      position: json['position'] ?? 0,
      style: json['style'] ?? '',
      defaultLanguage: json['defaultLanguage'] ?? '',
      localized: json['localized'] ?? '',
    );
  }
}

class ChannelSectionContentDetails {
  final List<String> playlists;
  final List<String> channels;

  ChannelSectionContentDetails({
    required this.playlists,
    required this.channels,
  });

  factory ChannelSectionContentDetails.fromJson(Map<String, dynamic> json) {
    return ChannelSectionContentDetails(
      playlists: List<String>.from(json['playlists'] ?? []),
      channels: List<String>.from(json['channels'] ?? []),
    );
  }
}

class YouTubeChannelSectionResponse {
  final String code;
  final String msg;
  final List<YouTubeChannelSection> items;

  YouTubeChannelSectionResponse({
    required this.code,
    required this.msg,
    required this.items,
  });

  factory YouTubeChannelSectionResponse.fromJson(Map<String, dynamic> json) {
    return YouTubeChannelSectionResponse(
      code: json['code']?.toString() ?? '',
      msg: json['msg'] ?? '',
      items: (json['items'] as List?)
              ?.map((item) => YouTubeChannelSection.fromJson(item))
              .toList() ??
          [],
    );
  }
}

enum ChannelSectionType {
  channelsectionTypeUndefined,
  singlePlaylist,
  multiplePlaylists,
  popularUploads,
  recentUploads,
  likes,
  allPlaylists,
  likedPlaylists,
  recentPosts,
  recentActivity,
  liveEvents,
  upcomingEvents,
  completedEvents,
  multipleChannels,
  postedVideos,
  postedPlaylists,
  subscriptions
}

class YouTubeChannelSectionInsertRequest {
  final ChannelSectionSnippetRequest snippet;
  final ChannelSectionContentDetailsRequest? contentDetails;

  YouTubeChannelSectionInsertRequest({
    required this.snippet,
    this.contentDetails,
  });

  Map<String, dynamic> toJson() {
    return {
      'snippet': snippet.toJson(),
      if (contentDetails != null) 'contentDetails': contentDetails!.toJson(),
    };
  }
}

class ChannelSectionSnippetRequest {
  final String type;
  final String? title;
  final int? position;

  ChannelSectionSnippetRequest({
    required this.type,
    this.title,
    this.position,
  }) {
    // Validate that type is one of the allowed values
    if (!ChannelSectionType.values.map((e) => e.name).contains(type)) {
      throw ArgumentError('Invalid channel section type: $type');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      if (title != null) 'title': title,
      if (position != null) 'position': position,
    };
  }
}

class ChannelSectionContentDetailsRequest {
  final List<String>? playlists;
  final List<String>? channels;

  ChannelSectionContentDetailsRequest({
    this.playlists,
    this.channels,
  });

  Map<String, dynamic> toJson() {
    return {
      if (playlists != null && playlists!.isNotEmpty) 'playlists': playlists,
      if (channels != null && channels!.isNotEmpty) 'channels': channels,
    };
  }
} 