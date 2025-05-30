import 'dart:convert';
import 'package:get/get.dart';
import '../../core/api_client.dart';
import '../../core/base_view_model.dart';
import '../../data/models/channel_section.dart';

class ChannelSectionViewModel extends BaseViewModel {
  final ApiClient _apiClient;
  

  final RxList<ChannelSection> sections = <ChannelSection>[].obs;
  final Rx<ChannelSection?> selectedSection = Rx<ChannelSection?>(null);

  ChannelSectionViewModel({required ApiClient apiClient})
      : _apiClient = apiClient;

  Future<void> loadSections({String? id, String? channelId, String? mine}) async {
    try {
      setLoading(true);
      clearError();

      final queryParams = {
        if (id != null) 'id': id,
        if (channelId != null) 'channelId': channelId,
        if (mine != null) 'mine': mine,
      };

      final response = await _apiClient.get(
        '/plat/youtube/channels/sections/list',
        queryParams: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        sections.value = data.map((json) => ChannelSection.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load sections: ${response.reasonPhrase}');
      }
    } catch (e) {
      handleError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<void> insertSection(ChannelSection section) async {
    try {
      setLoading(true);
      clearError();

      final response = await _apiClient.post(
        '/channels/sections/insert',
        body: json.encode(section.toJson()),
      );

      if (response.statusCode == 200) {
        await loadSections(); 
      } else {
        throw Exception('Failed to insert section: ${response.reasonPhrase}');
      }
    } catch (e) {
      handleError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateSection(ChannelSection section) async {
    try {
      setLoading(true);
      clearError();

      final response = await _apiClient.post(
        '/channels/sections/update',
        body: json.encode(section.toJson()),
      );

      if (response.statusCode == 200) {
        await loadSections();
      } else {
        throw Exception('Failed to update section: ${response.reasonPhrase}');
      }
    } catch (e) {
      handleError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteSection(String sectionId) async {
    try {
      setLoading(true);
      clearError();

      final response = await _apiClient.post(
        '/channels/sections/delete',
        body: json.encode({'id': sectionId}),
      );

      if (response.statusCode == 200) {
        sections.removeWhere((section) => section.id == sectionId);
      } else {
        throw Exception('Failed to delete section: ${response.reasonPhrase}');
      }
    } catch (e) {
      handleError(e);
    } finally {
      setLoading(false);
    }
  }

  void selectSection(ChannelSection section) {
    selectedSection.value = section;
  }

  @override
  void onInit() {
    super.onInit();
    loadSections();
  }
} 