class YouTubeChannel {
  final String channelId;
  final BrandingSettings? brandingSettings;

  YouTubeChannel({
    required this.channelId,
    this.brandingSettings,
  });

  factory YouTubeChannel.fromJson(Map<String, dynamic> json) {
    return YouTubeChannel(
      channelId: json['channelId'] ?? '',
      brandingSettings: json['brandingSettings'] != null
          ? BrandingSettings.fromJson(json['brandingSettings'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channelId': channelId,
      'brandingSettings': brandingSettings?.toJson(),
    };
  }
}

class BrandingSettings {
  final ChannelSettings channel;

  BrandingSettings({
    required this.channel,
  });

  factory BrandingSettings.fromJson(Map<String, dynamic> json) {
    return BrandingSettings(
      channel: ChannelSettings.fromJson(json['channel'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel': channel.toJson(),
    };
  }
}

class ChannelSettings {
  final String country;
  final String description;
  final String defaultLanguage;
  final String trackingAnalyticsAccountId;
  final String unsubscribedTrailer;
  final String keywords;

  ChannelSettings({
    this.country = '',
    this.description = '',
    this.defaultLanguage = '',
    this.trackingAnalyticsAccountId = '',
    this.unsubscribedTrailer = '',
    this.keywords = '',
  });

  factory ChannelSettings.fromJson(Map<String, dynamic> json) {
    return ChannelSettings(
      country: json['country'] ?? '',
      description: json['description'] ?? '',
      defaultLanguage: json['defaultLanguage'] ?? '',
      trackingAnalyticsAccountId: json['trackingAnalyticsAccountId'] ?? '',
      unsubscribedTrailer: json['unsubscribedTrailer'] ?? '',
      keywords: json['keywords'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'description': description,
      'defaultLanguage': defaultLanguage,
      'trackingAnalyticsAccountId': trackingAnalyticsAccountId,
      'unsubscribedTrailer': unsubscribedTrailer,
      'keywords': keywords,
    };
  }
} 