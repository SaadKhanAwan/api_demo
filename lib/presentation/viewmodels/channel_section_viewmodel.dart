import 'dart:convert';
import 'dart:developer' as developer;
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

      static const List<String> sampleChannelIds = [
    'UCuAXFkgsw1L7xaCfnd5JJOw',    // MrBeast
    'UCX6OQ3DkcsbYNE6H8uQQuVA',    // MrBeast Gaming
    'UC-lHJZR3Gqxm24_Vd_AJ5Yw',    // PewDiePie
    'UCbCmjCuTUZos6Inko4u57UQ',    // Cocomelon - Nursery Rhymes
    'UCpko_-a4wgz2u_DgDgd9fqA',    // WWE
    'UCBR8-60-B28hp2BmDPdntcQ',    // YouTube (official)
    'UCYfdidRxbB8Qhf0Nx7ioOYw',    // Crash Course
    'UC38IQsAvIsxxjztdMZQtwHA',    // Dude Perfect
    'UCHnyfMqiRRG1u-2MsSQLbXA',    // Veritasium
    'UCsooa4yRKGN_zEE8iknghZA',    // TED-Ed
  ];

  // Sample section IDs (these might not be real, as section IDs are harder to find)
  static const List<String> sampleSectionIds = [
    'UC-lHJZR3Gqxm24_Vd_AJ5Yw.featured',
    'UC-lHJZR3Gqxm24_Vd_AJ5Yw.uploads',
    'UC-lHJZR3Gqxm24_Vd_AJ5Yw.playlists',
  ];


  Future<void> loadSections({String? id, String? channelId, bool? mine}) async {
    try {
      setLoading(true);
      clearError();

      // Validate that at least one parameter is provided
      if (id == null && channelId == null && mine == null) {
        throw Exception('At least one parameter (id, channelId, or mine) must be specified');
      }

      final queryParams = {
        if (id != null) 'id': id,
        if (channelId != null) 'channelId': channelId,
        if (mine != null) 'mine': mine.toString(),
      };

      developer.log('Loading channel sections with params: $queryParams');

      final response = await _apiClient.get(
        '/plat/youtube/channels/sections/list',
        queryParams: queryParams,
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        developer.log('Channel sections response: ${response.body}');
        
        try {
          if (jsonResponse['code'] == 0 || jsonResponse['code'] == '0') {
            final data = jsonResponse['data'];
            if (data != null && data['items'] is List) {
              final List<dynamic> items = data['items'];
              sections.value = items.map((item) {
                // Convert the type to match our enum format
                if (item['snippet'] != null) {
                  String type = item['snippet']['type'] ?? '';
                  // Convert to camelCase if it's not already
                  if (type.toLowerCase() == 'channelsectiontypeundefined') {
                    type = 'channelsectionTypeUndefined';
                  }
                  item['snippet']['type'] = type;
                }
                return ChannelSection.fromJson(item);
              }).toList();
              
              developer.log('Successfully loaded ${sections.length} channel sections');
            } else {
              sections.value = [];
              developer.log('No sections found in response');
            }
          } else {
            final errorMsg = 'Failed to load channel sections: ${jsonResponse['msg']}';
            developer.log(errorMsg);
            throw Exception(errorMsg);
          }
        } catch (e) {
          final errorMsg = e.toString().replaceAll('Exception: ', '');
          developer.log('Error parsing channel sections response: $errorMsg');
          throw Exception(errorMsg);
        }
      } else {
        final errorMsg = 'Failed to load sections: ${response.reasonPhrase}';
        developer.log(errorMsg, error: response.statusCode);
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      developer.log('Error loading channel sections', error: e, stackTrace: stackTrace);
      handleError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<void> insertSection(ChannelSection section) async {
    try {
      setLoading(true);
      clearError();

      // Format request body according to YouTube API requirements
      final requestBody = {
        'snippet': {
          'type': section.snippet.type.name,
          if (section.snippet.title.isNotEmpty) 'title': section.snippet.title,
          if (section.snippet.position > 0) 'position': section.snippet.position,
        },
        if (section.contentDetails!.playlists.isNotEmpty || section.contentDetails!.channels.isNotEmpty)
          'contentDetails': {
            if (section.contentDetails!.playlists.isNotEmpty)
              'playlists': section.contentDetails!.playlists,
            if (section.contentDetails!.channels.isNotEmpty)
              'channels': section.contentDetails?.channels,
          },
      };

      developer.log('Attempting to insert channel section with body: ${json.encode(requestBody)}');

      final response = await _apiClient.post(
        '/plat/youtube/channels/sections/insert',
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        developer.log('Insert section response: ${response.body}');
        
        if (jsonResponse['code'] == '0' || jsonResponse['code'] == 0) {
          // Refresh the sections list to include the new section
          await loadSections(channelId: sampleChannelIds[0]);
          developer.log('Successfully inserted channel section');
        } else {
          final errorMsg = 'Failed to insert section: ${jsonResponse['msg']}';
          developer.log(errorMsg);
          throw Exception(errorMsg);
        }
      } else {
        final errorMsg = 'Failed to insert section: ${response.reasonPhrase}';
        developer.log(errorMsg, error: response.statusCode);
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      developer.log('Error inserting channel section', error: e, stackTrace: stackTrace);
      handleError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateSection(ChannelSection section) async {
    try {
      setLoading(true);
      clearError();

      if (section.id == null) {
        throw Exception('Section ID is required for update');
      }

      // Format request body according to YouTube API requirements
      final requestBody = {
        'id': section.id,
        'snippet': {
          'type': section.snippet.type.name,
          if (section.snippet.title.isNotEmpty) 'title': section.snippet.title,
          if (section.snippet.position > 0) 'position': section.snippet.position,
        },
        if (section.contentDetails != null && 
            (section.contentDetails!.playlists.isNotEmpty || section.contentDetails!.channels.isNotEmpty))
          'contentDetails': {
            if (section.contentDetails!.playlists.isNotEmpty)
              'playlists': section.contentDetails!.playlists,
            if (section.contentDetails!.channels.isNotEmpty)
              'channels': section.contentDetails!.channels,
          },
      };

      developer.log('Attempting to update channel section: ${section.id}');
      developer.log('Request body: ${json.encode(requestBody)}');

      final response = await _apiClient.post(
        '/plat/youtube/channels/sections/update',
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        developer.log('Update section response: ${response.body}');
        
        if (jsonResponse['code'] == '0' || jsonResponse['code'] == 0 || response.statusCode == 201) {
          // Refresh the sections list to reflect the update
          await loadSections(channelId: sampleChannelIds[0]);
          developer.log('Successfully updated channel section: ${section.id}');
        } else {
          final errorMsg = 'Failed to update section: ${jsonResponse['msg']}';
          developer.log(errorMsg);
          throw Exception(errorMsg);
        }
      } else {
        final errorMsg = 'Failed to update section: ${response.reasonPhrase}';
        developer.log(errorMsg, error: response.statusCode);
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      developer.log('Error updating channel section', error: e, stackTrace: stackTrace);
      handleError(e);
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteSection(String sectionId) async {
    try {
      setLoading(true);
      clearError();

      developer.log('Attempting to delete channel section: $sectionId');

      final response = await _apiClient.post(
        '/plat/youtube/channels/sections/delete',
        body: json.encode({'id': sectionId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        developer.log('Delete section response: ${response.body}');
        
        if (jsonResponse['code'] == '0' || jsonResponse['code'] == 0 || response.statusCode == 201) {
          // Remove the section from the local list
          sections.removeWhere((section) => section.id == sectionId);
          developer.log('Successfully deleted channel section: $sectionId');
        } else {
          final errorMsg = 'Failed to delete section: ${jsonResponse['msg']}';
          developer.log(errorMsg);
          throw Exception(errorMsg);
        }
      } else {
        final errorMsg = 'Failed to delete section: ${response.reasonPhrase}';
        developer.log(errorMsg, error: response.statusCode);
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      developer.log('Error deleting channel section', error: e, stackTrace: stackTrace);
      handleError(e);
    } finally {
      setLoading(false);
    }
  }

  void selectSection(ChannelSection section) {
    selectedSection.value = section;
  }

  // Helper method to load sections for the authenticated user
  Future<void> loadMySections() async {
    await loadSections(mine: true);
  }

  // Helper method to load sections for a specific channel
  Future<void> loadChannelSections(String channelId) async {
    await loadSections(channelId: channelId);
  }

  // Helper method to load sections by IDs
  Future<void> loadSectionsByIds(List<String> sectionIds) async {
    if (sectionIds.isEmpty) return;
    await loadSections(id: sectionIds.join(','));
  }

  @override
  void onInit() {
    super.onInit();
    // Load sections for a sample channel
    loadSections(channelId: sampleChannelIds[0]);
  }
} 