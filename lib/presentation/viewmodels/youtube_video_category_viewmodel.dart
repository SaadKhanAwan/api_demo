import 'dart:convert';
import 'dart:developer' as developer;
import 'package:get/get.dart';
import '../../core/api_client.dart';
import '../../core/base_view_model.dart';
import '../../data/models/youtube_video_category.dart';

class YouTubeVideoCategoryViewModel extends BaseViewModel {
  final ApiClient _apiClient;
  
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

  YouTubeVideoCategoryViewModel({required ApiClient apiClient})
      : _apiClient = apiClient;

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

        if (jsonResponse['code'] == 0 || jsonResponse['code'] == '0') {
          final data = jsonResponse['data'];
          if (data != null && data['items'] is List) {
            categories.value = (data['items'] as List)
                .map((item) => YouTubeVideoCategory.fromJson(item))
                .toList();
            developer.log('Successfully loaded ${categories.length} video categories');
          } else {
            categories.value = [];
            developer.log('No categories found in response data');
          }
        } else {
          final errorMsg = 'Failed to load video categories: ${jsonResponse['msg']}';
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

  Future<void> loadVideoCategoriesByIds(List<String> categoryIds) async {
    if (categoryIds.isEmpty) return;
    await loadVideoCategories(id: categoryIds.join(','));
  }

  Future<void> loadVideoCategoriesByRegion(String regionCode) async {
    await loadVideoCategories(regionCode: regionCode.toUpperCase());
  }

  Future<void> loadUSVideoCategories() async {
    await loadVideoCategoriesByRegion('US');
  }

  void selectCategory(YouTubeVideoCategory category) {
    selectedCategory.value = category;
  }

  YouTubeVideoCategory? getCategoryById(String id) {
    return categories.firstWhereOrNull((category) => category.id == id);
  }

  String getCategoryTitleById(String id) {
    return getCategoryById(id)?.snippet.title ?? 'Unknown Category';
  }

  @override
  void onInit() {
    super.onInit();
    // Load sample categories for testing
    loadVideoCategoriesByIds(sampleCategoryIds.take(5).toList());
  }
} 