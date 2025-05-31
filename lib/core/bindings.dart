import 'package:get/get.dart';
import 'api_client.dart';
import '../presentation/viewmodels/youtube_channel_viewmodel.dart';
import '../presentation/viewmodels/youtube_video_viewmodel.dart';
import '../presentation/viewmodels/channel_section_viewmodel.dart';
import '../presentation/viewmodels/youtube_video_category_viewmodel.dart';
import '../presentation/viewmodels/youtube_playlist_viewmodel.dart';
import '../presentation/viewmodels/youtube_playlist_item_viewmodel.dart';

class YouTubeBindings extends Bindings {
  @override
  void dependencies() {
    // Initialize API client
    final apiClient = ApiClient(
      authToken: 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY4MzNlYTJlY2Y0ZTE5ODhiMzg2M2YyZSIsIm5hbWUiOiLnlKjmiLdfTTRob2l3dlEiLCJpc01hbmFnZXIiOmZhbHNlLCJpYXQiOjE3NDg2NjQ4MTMsImV4cCI6MTc1MTI1NjgxM30.gFV3w-gMJPWtYiyUlFUeRJ7_Scpi21d5qzjKTYf-vbc'
    );
    
    // Initialize ViewModels
    Get.put(YouTubeChannelViewModel(apiClient: apiClient));
    Get.put(YouTubeVideoViewModel(apiClient: apiClient));
    Get.put(ChannelSectionViewModel(apiClient: apiClient));
    Get.put(YouTubeVideoCategoryViewModel(apiClient: apiClient));
    Get.put(YouTubePlaylistViewModel(apiClient: apiClient));
    Get.put(YouTubePlaylistItemViewModel(apiClient: apiClient));
  }
} 