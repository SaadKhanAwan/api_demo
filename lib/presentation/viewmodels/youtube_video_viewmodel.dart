import 'dart:convert';
import 'dart:developer' as developer;
import 'package:get/get.dart';
import '../../core/api_client.dart';
import '../../core/base_view_model.dart';
import '../../data/models/youtube_video.dart';
import '../../data/models/youtube_video_response.dart';
import '../../data/models/youtube_rated_video_response.dart';
import '../../data/models/youtube_video_upload.dart';
import '../../data/models/youtube_video_category.dart';

class YouTubeVideoViewModel extends BaseViewModel {
  // Sample video IDs for testing
  static const List<String> sampleVideoIds = [
    'dQw4w9WgXcQ',    // Rick Astley - Never Gonna Give You Up
    'jNQXAC9IVRw',    // Me at the zoo (First YouTube video)
    'kJQP7kiw5Fk',    // Luis Fonsi - Despacito
    '9bZkp7q19f0',    // PSY - Gangnam Style
    'JGwWNGJdvx8',    // Ed Sheeran - Shape of You
  ];

  final ApiClient _apiClient;
  
  final RxList<YouTubeVideo> videos = <YouTubeVideo>[].obs;
  final RxList<YouTubeVideo> ratedVideos = <YouTubeVideo>[].obs;
  final Rx<YouTubeVideo?> selectedVideo = Rx<YouTubeVideo?>(null);
  final RxList<YouTubeVideoCategory> categories = <YouTubeVideoCategory>[].obs;
  final Rx<YouTubeVideoCategory?> selectedCategory = Rx<YouTubeVideoCategory?>(null);

  // Sample category IDs for testing
  static const List<String> sampleCategoryIds = [
    '1',   // Film & Animation
    '2',   // Autos & Vehicles
    '10',  // Music
    '15',  // Pets & Animals
    '17',  // Sports
    '20',  // Gaming
    '22',  // People & Blogs
    '23',  // Comedy
    '24',  // Entertainment
    '25',  // News & Politics
  ];

  // Common region codes
  static const List<String> commonRegionCodes = [
    'US',  // United States
    'GB',  // United Kingdom
    'CA',  // Canada
    'AU',  // Australia
    'IN',  // India
  ];

  YouTubeVideoViewModel({required ApiClient apiClient})
      : _apiClient = apiClient;

  Future<void> loadVideos({String? id, String? myRating, String? chart}) async {
    try {
      setLoading(true);
      clearError();
      
      // Validate that at least one filter parameter is provided
      if (id == null && myRating == null && chart == null) {
        throw Exception('At least one filter parameter (myRating, id, or chart) must be specified');
      }

      final queryParams = {
        if (id != null) 'id': id,
        if (myRating != null) 'myRating': myRating,
        if (chart != null) 'chart': chart,
      };

      developer.log('Loading videos with params: $queryParams');

      final response = await _apiClient.get(
        '/plat/youtube/videos/list',
        queryParams: queryParams,
      );
      
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        developer.log('Video list response: ${response.body}');
        
        if (jsonResponse['code'] == 0 && jsonResponse['data'] != null) {
          final videoResponse = YouTubeVideoResponse.fromJson(jsonResponse['data']);
          videos.value = videoResponse.items;
          developer.log('Successfully loaded ${videos.length} videos');
        } else {
          final errorMsg = 'Failed to load videos: ${jsonResponse['msg']}';
          developer.log(errorMsg, error: jsonResponse);
          throw Exception(errorMsg);
        }
      } else {
        final errorMsg = 'Failed to load videos: ${response.reasonPhrase}';
        developer.log(errorMsg, error: response.statusCode);
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      developer.log('Error loading videos', error: e, stackTrace: stackTrace);
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

      developer.log('Loading rated videos with params: $queryParams');

      final response = await _apiClient.get(
        '/plat/youtube/videos/rate/list',
        queryParams: queryParams,
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        developer.log('Rated videos response: ${response.body}');
        
        final ratedResponse = YouTubeRatedVideoResponse.fromJson(jsonResponse);
        
        if (ratedResponse.code == '0') {
          // First load the video details for the rated videos
          final videoIds = ratedResponse.items.map((item) => item.videoId).join(',');
          await loadVideos(id: videoIds);
          
          // Now update the ratings in the videos list
          final ratedVideosMap = {
            for (var item in ratedResponse.items) item.videoId: item.rating
          };
          
          // Filter videos that have ratings and update their rating property
          ratedVideos.value = videos.where((video) => ratedVideosMap.containsKey(video.id))
              .map((video) => YouTubeVideo(
                    kind: video.kind,
                    etag: video.etag,
                    id: video.id,
                    rating: ratedVideosMap[video.id] ?? 'none',
                    snippet: video.snippet,
                    contentDetails: video.contentDetails,
                    status: video.status,
                    statistics: video.statistics,
                    topicDetails: video.topicDetails,
                  ))
              .toList();
          
          developer.log('Successfully loaded ${ratedVideos.length} rated videos');
        } else {
          final errorMsg = 'Failed to load rated videos: ${ratedResponse.msg}';
          developer.log(errorMsg);
          throw Exception(errorMsg);
        }
      } else {
        final errorMsg = 'Failed to load rated videos: ${response.reasonPhrase}';
        developer.log(errorMsg, error: response.statusCode);
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      developer.log('Error loading rated videos', error: e, stackTrace: stackTrace);
      handleError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteVideo(String videoId) async {
    try {
      setLoading(true);
      clearError();

      developer.log('Attempting to delete video: $videoId');
      
      final response = await _apiClient.post(
        '/plat/youtube/videos/delete',
        body: json.encode({'id': videoId}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        developer.log('Delete video response: ${response.body}');
        
        if (jsonResponse['code'] == 0) {
          // Check if the response contains the deleted video ID
          final responseData = jsonResponse['data'];
          if (responseData != null && responseData['id'] == videoId) {
            // Remove the video from both lists
            videos.removeWhere((video) => video.id == videoId);
            ratedVideos.removeWhere((video) => video.id == videoId);
            developer.log('Successfully deleted video: $videoId');
          } else {
            final errorMsg = 'Delete response ID mismatch or missing';
            developer.log(errorMsg, error: jsonResponse);
            throw Exception(errorMsg);
          }
        } else {
          final errorMsg = 'Failed to delete video: ${jsonResponse['msg']}';
          developer.log(errorMsg, error: jsonResponse);
          throw Exception(errorMsg);
        }
      } else {
        final errorMsg = 'Failed to delete video: ${response.reasonPhrase}';
        developer.log(errorMsg, error: response.statusCode);
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      developer.log('Error deleting video', error: e, stackTrace: stackTrace);
      handleError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<void> rateVideo(String videoId, VideoRating rating) async {
    try {
      setLoading(true);
      clearError();

      developer.log('Attempting to rate video: $videoId with rating: ${rating.name}');

      final response = await _apiClient.post(
        '/plat/youtube/videos/rate',
        body: json.encode({
          'id': videoId,
          'rating': rating.name,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        developer.log('Rate video response: ${response.body}');
        
        if (jsonResponse['code'] == 0) {
          final responseData = jsonResponse['data'];
          if (responseData != null && 
              responseData['id'] == videoId && 
              responseData['rating'] == rating.name) {
            // Update the rating in local lists
            _updateVideoRating(videoId, rating);
            developer.log('Successfully rated video: $videoId with rating: ${rating.name}');
          } else {
            const errorMsg = 'Rate response data mismatch or missing';
            developer.log(errorMsg, error: jsonResponse);
            throw Exception(errorMsg);
          }
        } else {
          final errorMsg = 'Failed to rate video: ${jsonResponse['msg']}';
          developer.log(errorMsg, error: jsonResponse);
          throw Exception(errorMsg);
        }
      } else {
        final errorMsg = 'Failed to rate video: ${response.reasonPhrase}';
        developer.log(errorMsg, error: response.statusCode);
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      developer.log('Error rating video', error: e, stackTrace: stackTrace);
      handleError(e);
    } finally {
      setLoading(false);
    }
  }

  void _updateVideoRating(String videoId, VideoRating rating) {
    // Update in main videos list
    final videoIndex = videos.indexWhere((v) => v.id == videoId);
    if (videoIndex != -1) {
      final video = videos[videoIndex];
      videos[videoIndex] = YouTubeVideo(
        kind: video.kind,
        etag: video.etag,
        id: video.id,
        rating: rating.name,
        snippet: video.snippet,
        contentDetails: video.contentDetails,
        status: video.status,
        statistics: video.statistics,
        topicDetails: video.topicDetails,
      );
    }

    // Update in rated videos list
    final ratedIndex = ratedVideos.indexWhere((v) => v.id == videoId);
    if (ratedIndex != -1) {
      final video = ratedVideos[ratedIndex];
      ratedVideos[ratedIndex] = YouTubeVideo(
        kind: video.kind,
        etag: video.etag,
        id: video.id,
        rating: rating.name,
        snippet: video.snippet,
        contentDetails: video.contentDetails,
        status: video.status,
        statistics: video.statistics,
        topicDetails: video.topicDetails,
      );
    }

    // If rating is none (cancel), remove from rated videos
    if (rating == VideoRating.none) {
      ratedVideos.removeWhere((v) => v.id == videoId);
    }
  }

  // Helper methods for rating videos
  Future<void> likeVideo(String videoId) async {
    await rateVideo(videoId, VideoRating.like);
  }

  Future<void> dislikeVideo(String videoId) async {
    await rateVideo(videoId, VideoRating.dislike);
  }

  Future<void> cancelRating(String videoId) async {
    await rateVideo(videoId, VideoRating.none);
  }

  void selectVideo(YouTubeVideo video) {
    selectedVideo.value = video;
  }

  Future<void> loadLikedVideos() async {
    await loadVideos(myRating: 'like');
  }

  Future<void> loadDislikedVideos() async {
    await loadVideos(myRating: 'dislike');
  }

  Future<void> loadVideosByIds(List<String> videoIds) async {
    if (videoIds.isEmpty) return;
    await loadVideos(id: videoIds.join(','));
  }

  Future<String?> uploadVideo({
    required String filePath,
    String? title,
    String? description,
    List<String>? keywords,
    String? categoryId,
    String? privacyStatus,
  }) async {
    try {
      setLoading(true);
      clearError();

      developer.log('Attempting to upload video', error: {
        'filePath': filePath,
        'title': title,
        'description': description,
        'keywords': keywords,
        'categoryId': categoryId,
        'privacyStatus': privacyStatus,
      });

      final request = YouTubeVideoUploadRequest(
        file: filePath,
        title: title,
        description: description,
        keywords: keywords,
        categoryId: categoryId,
        privacyStatus: privacyStatus,
      );

      final response = await _apiClient.post(
        '/plat/youtube/videos/upload',
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        developer.log('Upload video response: ${response.body}');
        
        final uploadResponse = YouTubeVideoUploadResponse.fromJson(jsonResponse);
        
        if (uploadResponse.code == '0') {
          developer.log('Successfully uploaded video with ID: ${uploadResponse.videoId}');
          
          // Refresh the video list to include the new video
          await loadVideos(id: uploadResponse.videoId);
          
          return uploadResponse.videoId;
        } else {
          final errorMsg = 'Failed to upload video: ${uploadResponse.msg}';
          developer.log(errorMsg);
          throw Exception(errorMsg);
        }
      } else {
        final errorMsg = 'Failed to upload video: ${response.reasonPhrase}';
        developer.log(errorMsg, error: response.statusCode);
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      developer.log('Error uploading video', error: e, stackTrace: stackTrace);
      handleError(e);
      return null;
    } finally {
      setLoading(false);
    }
  }

  // Helper method for quick video upload with minimal parameters
  Future<String?> quickUpload(String filePath, {String? title}) async {
    return uploadVideo(
      filePath: filePath,
      title: title,
      privacyStatus: 'private', // Default to private for testing
    );
  }

  // Helper method for detailed video upload
  Future<String?> uploadVideoWithDetails({
    required String filePath,
    required String title,
    required String description,
    required List<String> keywords,
    required String categoryId,
    String privacyStatus = 'private',
  }) async {
    return uploadVideo(
      filePath: filePath,
      title: title,
      description: description,
      keywords: keywords,
      categoryId: categoryId,
      privacyStatus: privacyStatus,
    );
  }

  // Video Categories Methods
  Future<void> loadVideoCategories({
    String? id,
    String? regionCode,
  }) async {
    try {
      // Validate that exactly one parameter is provided
      final parameters = [id, regionCode].where((param) => param != null).length;
      if (parameters == 0) {
        throw Exception('Either id or regionCode must be specified');
      }
      if (parameters > 1) {
        throw Exception('Only one of id or regionCode can be specified');
      }

      // Validate regionCode format if provided
      if (regionCode != null && regionCode.length != 2) {
        throw Exception('regionCode must be a 2-letter country code (e.g., US, GB)');
      }

      setLoading(true);
      clearError();

      final queryParams = {
        if (id != null) 'id': id,
        if (regionCode != null) 'regionCode': regionCode.toUpperCase(),
      };

      developer.log('Loading video categories with params: $queryParams');

      final response = await _apiClient.get(
        '/plat/youtube/video/categories/list',
        queryParams: queryParams,
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        developer.log('Video categories response: ${response.body}');

        final categoryResponse = YouTubeVideoCategoryResponse.fromJson(jsonResponse);

        if (categoryResponse.code == '0') {
          categories.value = categoryResponse.items;
          developer.log('Successfully loaded ${categories.length} video categories');
        } else {
          final errorMsg = 'Failed to load video categories: ${categoryResponse.msg}';
          developer.log(errorMsg);
          throw Exception(errorMsg);
        }
      } else {
        final errorMsg = 'Failed to load video categories: ${response.reasonPhrase}';
        developer.log(errorMsg, error: response.statusCode);
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      developer.log('Error loading video categories', error: e, stackTrace: stackTrace);
      handleError(e);
    } finally {
      setLoading(false);
    }
  }

  // Helper methods for loading video categories
  Future<void> loadVideoCategoriesByIds(List<String> categoryIds) async {
    if (categoryIds.isEmpty) return;
    await loadVideoCategories(id: categoryIds.join(','));
  }

  Future<void> loadVideoCategoriesByRegion(String regionCode) async {
    await loadVideoCategories(regionCode: regionCode.toUpperCase());
  }

  // Load categories for the US region (most common use case)
  Future<void> loadUSVideoCategories() async {
    await loadVideoCategoriesByRegion('US');
  }

  void selectCategory(YouTubeVideoCategory category) {
    selectedCategory.value = category;
  }

  // Get a category by ID from the loaded categories
  YouTubeVideoCategory? getCategoryById(String id) {
    return categories.firstWhereOrNull((category) => category.id == id);
  }

  // Get a category title by ID (useful for displaying category names)
  String getCategoryTitleById(String id) {
    return getCategoryById(id)?.snippet.title ?? 'Unknown Category';
  }

  @override
  void onInit() {
    super.onInit();
 loadVideos(
                    chart: 'mostPopular',
                    id: YouTubeVideoViewModel.sampleVideoIds.join(','),
                  );
                  loadRatedVideos(
                    id: YouTubeVideoViewModel.sampleVideoIds.join(','),
                  );
  }
} 