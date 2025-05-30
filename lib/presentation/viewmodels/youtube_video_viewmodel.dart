import 'dart:convert';
import 'package:get/get.dart';
import '../../core/api_client.dart';
import '../../core/base_view_model.dart';
import '../../data/models/youtube_video.dart';

class YouTubeVideoViewModel extends BaseViewModel {
  final ApiClient _apiClient;
  

  final RxList<YouTubeVideo> videos = <YouTubeVideo>[].obs;
  final RxList<YouTubeVideo> ratedVideos = <YouTubeVideo>[].obs;
  final Rx<YouTubeVideo?> selectedVideo = Rx<YouTubeVideo?>(null);

  YouTubeVideoViewModel({required ApiClient apiClient})
      : _apiClient = apiClient;

  Future<void> loadVideos({String? id, String? myRating}) async {
    try {
      setLoading(true);
      clearError();

      final queryParams = {
        if (id != null) 'id': id,
        if (myRating != null) 'myRating': myRating,
      };

      final response = await _apiClient.get(
        '/plat/youtube/videos/list',
        queryParams: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        videos.value = data.map((json) => YouTubeVideo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load videos: ${response.reasonPhrase}');
      }
    } catch (e) {
      handleError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadRatedVideos({String? id}) async {
    try {
      setLoading(true);
      clearError();

      final queryParams = {
        if (id != null) 'id': id,
      };

      final response = await _apiClient.get(
        '/plat/youtube/videos/rate/list',
        queryParams: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        ratedVideos.value = data.map((json) => YouTubeVideo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load rated videos: ${response.reasonPhrase}');
      }
    } catch (e) {
      handleError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteVideo(String videoId) async {
    try {
      setLoading(true);
      clearError();

      final response = await _apiClient.post(
        '/plat/youtube/videos/delete',
        body: json.encode({'id': videoId}),
      );

      if (response.statusCode == 200) {
        videos.removeWhere((video) => video.id == videoId);
        ratedVideos.removeWhere((video) => video.id == videoId);
      } else {
        throw Exception('Failed to delete video: ${response.reasonPhrase}');
      }
    } catch (e) {
      handleError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<void> rateVideo(String videoId, VideoRating rating) async {
    try {
      setLoading(true);
      clearError();

      final response = await _apiClient.post(
        '/plat/youtube/videos/rate',
        body: json.encode({
          'id': videoId,
          'rating': rating.toJson(),
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to rate video: ${response.reasonPhrase}');
      }

      await loadRatedVideos(); // Refresh rated videos list
    } catch (e) {
      handleError(e);
    } finally {
      setLoading(false);
    }
  }

  void selectVideo(YouTubeVideo video) {
    selectedVideo.value = video;
  }

  @override
  void onInit() {
    super.onInit();
    loadVideos();
    loadRatedVideos();
  }
} 