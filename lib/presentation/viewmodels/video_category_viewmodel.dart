import 'dart:convert';
import 'package:get/get.dart';
import '../../core/api_client.dart';
import '../../core/base_view_model.dart';
import '../../data/models/video_category.dart';

class VideoCategoryViewModel extends BaseViewModel {
  final ApiClient _apiClient;
  

  final RxList<VideoCategory> categories = <VideoCategory>[].obs;
  final Rx<VideoCategory?> selectedCategory = Rx<VideoCategory?>(null);
  final RxString selectedRegionCode = 'US'.obs;

  VideoCategoryViewModel({required ApiClient apiClient})
      : _apiClient = apiClient;

  Future<void> loadCategories({String? id, String? regionCode}) async {
    try {
      setLoading(true);
      clearError();

      final queryParams = {
        'regionCode': regionCode ?? selectedRegionCode.value,
        if (id != null) 'id': id,
      };

      final response = await _apiClient.get(
        '/plat/youtube/video/categories/list',
        queryParams: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        categories.value = data.map((json) => VideoCategory.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.reasonPhrase}');
      }
    } catch (e) {
      handleError(e);
    } finally {
      setLoading(false);
    }
  }

  void selectCategory(VideoCategory category) {
    selectedCategory.value = category;
  }

  void setRegionCode(String regionCode) {
    selectedRegionCode.value = regionCode;
    loadCategories(regionCode: regionCode);
  }

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }
} 