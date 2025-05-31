import 'package:api_integration/presentation/viewmodels/youtube_video_category_viewmodel.dart';
import 'package:get/get.dart';
import '../api_client.dart';
import '../../presentation/viewmodels/youtube_channel_viewmodel.dart';
import '../../presentation/viewmodels/youtube_video_viewmodel.dart';
import '../../presentation/viewmodels/channel_section_viewmodel.dart';
import '../../presentation/viewmodels/youtube_playlist_viewmodel.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Register API client
    Get.put(ApiClient());

    // Register ViewModels
    Get.put(YouTubeChannelViewModel(apiClient: Get.find()));
    Get.put(YouTubeVideoViewModel(apiClient: Get.find()));
    Get.put(YouTubeVideoCategoryViewModel(apiClient: Get.find()));
    Get.put(ChannelSectionViewModel(apiClient: Get.find()));
    Get.put(YouTubePlaylistViewModel(apiClient: Get.find()));
  }
} 