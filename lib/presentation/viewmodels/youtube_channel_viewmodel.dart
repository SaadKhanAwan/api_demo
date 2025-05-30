import 'dart:convert';
import 'package:get/get.dart';
import '../../core/api_client.dart';
import '../../core/base_view_model.dart';
import '../../data/models/youtube_channel.dart';

class YouTubeChannelViewModel extends BaseViewModel {
  final ApiClient _apiClient;
  
  
  final RxList<YouTubeChannel> channels = <YouTubeChannel>[].obs;
  final Rx<YouTubeChannel?> selectedChannel = Rx<YouTubeChannel?>(null);

  YouTubeChannelViewModel({required ApiClient apiClient})
      : _apiClient = apiClient;

  Future<void> loadChannels() async {
    try {
      setLoading(true);
      clearError();
      
      final response = await _apiClient.get('/plat/youtube/channels/list');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        channels.value = data.map((json) => YouTubeChannel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load channels: ${response.reasonPhrase}');
      }
    } catch (e) {
      handleError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateChannel(YouTubeChannel channel) async {
    try {
      setLoading(true);
      clearError();
      
      final response = await _apiClient.post(
        '/plat/youtube/channels/update',
        body: json.encode(channel.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update channel: ${response.reasonPhrase}');
      }
      
      await loadChannels(); 
    } catch (e) {
      handleError(e);
    } finally {
      setLoading(false);
    }
  }

  void selectChannel(YouTubeChannel channel) {
    selectedChannel.value = channel;
  }

  @override
  void onInit() {
    super.onInit();
    loadChannels();
  }
} 