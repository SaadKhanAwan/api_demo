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
  final ChannelSectionSnippet snippet;
  final ChannelSectionContentDetails contentDetails;

  ChannelSection({
    this.id,
    required this.snippet,
    required this.contentDetails,
  });

  factory ChannelSection.fromJson(Map<String, dynamic> json) {
    return ChannelSection(
      id: json['id'],
      snippet: ChannelSectionSnippet.fromJson(json['snippet'] ?? {}),
      contentDetails: ChannelSectionContentDetails.fromJson(json['contentDetails'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'snippet': snippet.toJson(),
      'contentDetails': contentDetails.toJson(),
    };
  }
}

class ChannelSectionSnippet {
  final ChannelSectionType type;
  final String title;
  final int position;

  ChannelSectionSnippet({
    required this.type,
    required this.title,
    required this.position,
  });

  factory ChannelSectionSnippet.fromJson(Map<String, dynamic> json) {
    return ChannelSectionSnippet(
      type: ChannelSectionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ChannelSectionType.channelsectionTypeUndefined,
      ),
      title: json['title'] ?? '',
      position: json['position'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toJson(),
      'title': title,
      'position': position,
    };
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

  Map<String, dynamic> toJson() {
    return {
      'playlists': playlists,
      'channels': channels,
    };
  }
} 