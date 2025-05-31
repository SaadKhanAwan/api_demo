class YouTubeChannelBranding {
  final String channelId;
  final BrandingSettings brandingSettings;

  YouTubeChannelBranding({
    required this.channelId,
    required this.brandingSettings,
  });

  factory YouTubeChannelBranding.fromJson(Map<String, dynamic> json) {
    return YouTubeChannelBranding(
      channelId: json['channelId'] ?? '',
      brandingSettings: BrandingSettings.fromJson(json['brandingSettings'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channelId': channelId,
      'brandingSettings': brandingSettings.toJson(),
    };
  }
}

class BrandingSettings {
  final ChannelBranding channel;

  BrandingSettings({
    required this.channel,
  });

  factory BrandingSettings.fromJson(Map<String, dynamic> json) {
    return BrandingSettings(
      channel: ChannelBranding.fromJson(json['channel'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel': channel.toJson(),
    };
  }
}

class ChannelBranding {
  final String country;
  final String description;
  final String defaultLanguage;
  final String trackingAnalyticsAccountId;
  final String unsubscribedTrailer;
  final String keywords;

  ChannelBranding({
    this.country = '',
    this.description = '',
    this.defaultLanguage = '',
    this.trackingAnalyticsAccountId = '',
    this.unsubscribedTrailer = '',
    this.keywords = '',
  });

  factory ChannelBranding.fromJson(Map<String, dynamic> json) {
    return ChannelBranding(
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