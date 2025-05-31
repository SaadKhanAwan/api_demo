import 'dart:convert';
import 'dart:developer' as developer;
import 'package:get/get.dart';
import '../../core/api_client.dart';
import '../../core/base_view_model.dart';
import '../../data/models/youtube_channel.dart';
import '../../data/models/youtube_channel_branding.dart';

class YouTubeChannelViewModel extends BaseViewModel {
  final ApiClient _apiClient;
  
  final RxList<YouTubeChannel> channels = <YouTubeChannel>[].obs;
  final Rx<YouTubeChannel?> selectedChannel = Rx<YouTubeChannel?>(null);

  // Sample channel IDs for testing
  static const List<String> sampleChannelIds = [
    'UC_x5XG1OV2P6uZZ5FSM9Ttw',  // Google Developers
    'UCJowOS1R0FnhipXVqEnYU1A',  // Flutter
    'UCYfdidRxbB8Qhf0Nx7ioOYw',  // Your test channel
  ];

  YouTubeChannelViewModel({required ApiClient apiClient})
      : _apiClient = apiClient;

  Future<void> loadChannels({bool? mine, String? handle, String? userName, String? id}) async {
    try {
      setLoading(true);
      clearError();
      
      final queryParams = {
        if (mine != null) 'mine': mine.toString(),
        if (handle != null) 'handle': handle,
        if (userName != null) 'userName': userName,
        if (id != null) 'id': id,
      };

      developer.log('Loading channels with params: $queryParams');

      final response = await _apiClient.get(
        '/plat/youtube/channels/list',
        queryParams: queryParams,
      );
      
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        developer.log('Channel response: ${response.body}');
        
        if (jsonResponse['code'] == 0 && jsonResponse['data'] != null) {
          final data = jsonResponse['data'];
          if (data['items'] != null && data['items'] is List) {
            channels.value = (data['items'] as List)
                .map((item) => YouTubeChannel.fromJson(item))
                .toList();
            developer.log('Successfully loaded ${channels.length} channels');
          } else {
            channels.value = [];
          }
        } else {
          throw Exception('Failed to load channels: ${jsonResponse['msg']}');
        }
      } else {
        throw Exception('Failed to load channels: ${response.reasonPhrase}');
      }
    } catch (e, stackTrace) {
      developer.log('Error loading channels', error: e, stackTrace: stackTrace);
      handleError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateChannel({
    required String channelId,
    String? country,
    String? description,
    String? defaultLanguage,
    String? trackingAnalyticsAccountId,
    String? unsubscribedTrailer,
    String? keywords,
  }) async {
    try {
      setLoading(true);
      clearError();

      final branding = YouTubeChannelBranding(
        channelId: channelId,
        brandingSettings: BrandingSettings(
          channel: ChannelBranding(
            country: country ?? '',
            description: description ?? '',
            defaultLanguage: defaultLanguage ?? '',
            trackingAnalyticsAccountId: trackingAnalyticsAccountId ?? '',
            unsubscribedTrailer: unsubscribedTrailer ?? '',
            keywords: keywords ?? '',
          ),
        ),
      );
      
      developer.log('Updating channel: $channelId');
      
      final response = await _apiClient.post(
        '/plat/youtube/channels/update',
        body: json.encode(branding.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        developer.log('Channel update response: ${response.body}');
        
        if (jsonResponse['code'] == 0) {
          await loadChannels(); // Refresh the list after update
          developer.log('Successfully updated channel: $channelId');
        } else {
          throw Exception('Failed to update channel: ${jsonResponse['msg']}');
        }
      } else {
        throw Exception('Failed to update channel: ${response.reasonPhrase}');
      }
    } catch (e, stackTrace) {
      developer.log('Error updating channel', error: e, stackTrace: stackTrace);
      handleError(e);
    } finally {
      setLoading(false);
    }
  }

  void selectChannel(YouTubeChannel channel) {
    selectedChannel.value = channel;
  }

  // Helper methods for loading channels
  Future<void> loadMyChannels() async {
    await loadChannels(mine: true);
  }

  Future<void> loadChannelsByIds(List<String> channelIds) async {
    if (channelIds.isEmpty) return;
    await loadChannels(id: channelIds.join(','));
  }

  Future<void> loadChannelByHandle(String handle) async {
    await loadChannels(handle: handle);
  }

  Future<void> loadChannelByUserName(String userName) async {
    await loadChannels(userName: userName);
  }

  @override
  void onInit() {
    super.onInit();
    // Load user's own channels by default
    loadMyChannels();
  }
}