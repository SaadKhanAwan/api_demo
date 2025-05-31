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
  subscriptions;

  String toJson() => name;
}

class ChannelSection {
  final String? id;
  final String kind;
  final String etag;
  final ChannelSectionSnippet snippet;
  final ChannelSectionContentDetails? contentDetails;

  ChannelSection({
    this.id,
    required this.kind,
    required this.etag,
    required this.snippet,
    this.contentDetails,
  });

  factory ChannelSection.fromJson(Map<String, dynamic> json) {
    return ChannelSection(
      id: json['id'],
      kind: json['kind'] ?? '',
      etag: json['etag'] ?? '',
      snippet: ChannelSectionSnippet.fromJson(json['snippet'] ?? {}),
      contentDetails: json['contentDetails'] != null
          ? ChannelSectionContentDetails.fromJson(json['contentDetails'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'kind': kind,
      'etag': etag,
      'snippet': snippet.toJson(),
      if (contentDetails != null) 'contentDetails': contentDetails!.toJson(),
    };
  }
}

class ChannelSectionSnippet {
  final ChannelSectionType type;
  final String channelId;
  final String title;
  final int position;

  ChannelSectionSnippet({
    required this.type,
    required this.channelId,
    this.title = '',
    required this.position,
  });

  factory ChannelSectionSnippet.fromJson(Map<String, dynamic> json) {
    String typeStr = json['type'] ?? 'channelsectionTypeUndefined';
    // Convert type string to match enum case
    typeStr = typeStr.toLowerCase() == 'channelsectiontypeundefined'
        ? 'channelsectionTypeUndefined'
        : typeStr;

    return ChannelSectionSnippet(
      type: ChannelSectionType.values.firstWhere(
        (e) => e.name.toLowerCase() == typeStr.toLowerCase(),
        orElse: () => ChannelSectionType.channelsectionTypeUndefined,
      ),
      channelId: json['channelId'] ?? '',
      title: json['title'] ?? '',
      position: json['position'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'channelId': channelId,
      if (title.isNotEmpty) 'title': title,
      'position': position,
    };
  }
}

class ChannelSectionContentDetails {
  final List<String> playlists;
  final List<String> channels;

  ChannelSectionContentDetails({
    this.playlists = const [],
    this.channels = const [],
  });

  factory ChannelSectionContentDetails.fromJson(Map<String, dynamic> json) {
    return ChannelSectionContentDetails(
      playlists: List<String>.from(json['playlists'] ?? []),
      channels: List<String>.from(json['channels'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (playlists.isNotEmpty) json['playlists'] = playlists;
    if (channels.isNotEmpty) json['channels'] = channels;
    return json;
  }
} 