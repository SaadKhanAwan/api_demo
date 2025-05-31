import 'dart:convert';
import 'dart:developer' as developer;
import 'package:get/get.dart';
import '../../core/api_client.dart';
import '../../core/base_view_model.dart';
import '../../data/models/youtube_playlist_item.dart';

class YouTubePlaylistItemViewModel extends BaseViewModel {
  final ApiClient _apiClient;
  
  final RxList<YouTubePlaylistItem> playlistItems = <YouTubePlaylistItem>[].obs;
  final RxString nextPageToken = ''.obs;
  final RxString prevPageToken = ''.obs;
  final Rx<PageInfo> pageInfo = PageInfo(totalResults: 0, resultsPerPage: 0).obs;

  YouTubePlaylistItemViewModel({required ApiClient apiClient})
      : _apiClient = apiClient;

  Future<void> loadPlaylistItems({
    String? id,
    String? playlistId,
  }) async {
    try {
      setLoading(true);
      clearError();

      // Ensure at least one parameter is provided
      if (id == null && playlistId == null) {
        throw Exception('Either id or playlistId must be provided');
      }

      final queryParams = {
        if (id != null) 'id': id,
        if (playlistId != null) 'playlistId': playlistId,
      };

      developer.log('Loading playlist items with params: $queryParams');

      final response = await _apiClient.get(
        '/plat/youtube/playlist/items/list',
        queryParams: queryParams,
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        developer.log('Playlist items response: ${response.body}');

        if (jsonResponse['code'] == 0 || jsonResponse['code'] == '0') {
          final itemsResponse = YouTubePlaylistItemListResponse.fromJson(jsonResponse);
          playlistItems.value = itemsResponse.items;
          nextPageToken.value = itemsResponse.nextPageToken ?? '';
          prevPageToken.value = itemsResponse.prevPageToken ?? '';
          pageInfo.value = itemsResponse.pageInfo;
          developer.log('Successfully loaded ${playlistItems.length} playlist items');
        } else {
          final errorMsg = 'Failed to load playlist items: ${jsonResponse['msg']}';
          developer.log(errorMsg);
          throw Exception(errorMsg);
        }
      } else {
        final errorMsg = 'Failed to load playlist items: ${response.reasonPhrase}';
        developer.log(errorMsg, error: response.statusCode);
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      developer.log('Error loading playlist items', error: e, stackTrace: stackTrace);
      handleError(e);
      Get.snackbar(
        'Error',
        'Failed to load playlist items',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> insertPlaylistItem({
    required String playlistId,
    required String videoId,
    String? channelId,
    String? kind,
    String? itemPlaylistId,
    int? position,
    String? note,
  }) async {
    try {
      setLoading(true);
      clearError();

      final request = YouTubePlaylistItemInsertRequest(
        playlistId: playlistId,
        resourceId: ResourceId(
          videoId: videoId,
          channelId: channelId,
          kind: kind,
          playlistId: itemPlaylistId,
        ),
        position: position,
        note: note,
      );

      developer.log('Inserting playlist item: ${json.encode(request.toJson())}');

      final response = await _apiClient.post(
        '/plat/youtube/playlist/items/list/insert',
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        developer.log('Insert playlist item response: ${response.body}');

        if (jsonResponse['code'] == 0 || jsonResponse['code'] == '0') {
          // Refresh the playlist items
          await loadPlaylistItems(playlistId: playlistId);
          
          Get.snackbar(
            'Success',
            'Video added to playlist successfully',
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          final errorMsg = 'Failed to insert playlist item: ${jsonResponse['msg']}';
          developer.log(errorMsg);
          throw Exception(errorMsg);
        }
      } else {
        final errorMsg = 'Failed to insert playlist item: ${response.reasonPhrase}';
        developer.log(errorMsg, error: response.statusCode);
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      developer.log('Error inserting playlist item', error: e, stackTrace: stackTrace);
      handleError(e);
      Get.snackbar(
        'Error',
        'Failed to add video to playlist',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> updatePlaylistItem({
    required String id,
    required String playlistId,
    required String videoId,
    int? position,
    String? note,
  }) async {
    try {
      setLoading(true);
      clearError();

      final request = YouTubePlaylistItemUpdateRequest(
        id: id,
        playlistId: playlistId,
        videoId: videoId,
        position: position,
        note: note,
      );

      developer.log('Updating playlist item: ${json.encode(request.toJson())}');

      final response = await _apiClient.post(
        '/plat/youtube/playlist/items/list/update',
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        developer.log('Update playlist item response: ${response.body}');

        if (jsonResponse['code'] == 0 || jsonResponse['code'] == '0') {
          // Refresh the playlist items
          await loadPlaylistItems(playlistId: playlistId);
          
          Get.snackbar(
            'Success',
            'Playlist item updated successfully',
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          final errorMsg = 'Failed to update playlist item: ${jsonResponse['msg']}';
          developer.log(errorMsg);
          throw Exception(errorMsg);
        }
      } else {
        final errorMsg = 'Failed to update playlist item: ${response.reasonPhrase}';
        developer.log(errorMsg, error: response.statusCode);
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      developer.log('Error updating playlist item', error: e, stackTrace: stackTrace);
      handleError(e);
      Get.snackbar(
        'Error',
        'Failed to update playlist item',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> deletePlaylistItem({
    required String id,
    String? playlistId,  // Optional: used to refresh the list after deletion
  }) async {
    try {
      setLoading(true);
      clearError();

      developer.log('Deleting playlist item: $id');

      final response = await _apiClient.post(
        '/plat/youtube/playlist/items/list/delete',
        body: json.encode({'id': id}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        developer.log('Delete playlist item response: ${response.body}');

        if (jsonResponse['code'] == 0 || jsonResponse['code'] == '0') {
          // If we have the playlistId, refresh the items
          if (playlistId != null) {
            await loadPlaylistItems(playlistId: playlistId);
          } else {
            // Remove the item from the local list if we have it
            playlistItems.removeWhere((item) => item.id == id);
          }
          
          Get.snackbar(
            'Success',
            'Video removed from playlist successfully',
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          final errorMsg = 'Failed to delete playlist item: ${jsonResponse['msg']}';
          developer.log(errorMsg);
          throw Exception(errorMsg);
        }
      } else {
        final errorMsg = 'Failed to delete playlist item: ${response.reasonPhrase}';
        developer.log(errorMsg, error: response.statusCode);
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      developer.log('Error deleting playlist item', error: e, stackTrace: stackTrace);
      handleError(e);
      Get.snackbar(
        'Error',
        'Failed to remove video from playlist',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setLoading(false);
    }
  }
} 