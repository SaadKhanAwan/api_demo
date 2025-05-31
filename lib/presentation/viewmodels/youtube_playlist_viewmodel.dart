import 'dart:convert';
import 'dart:developer' as developer;
import 'package:get/get.dart';
import '../../core/api_client.dart';
import '../../core/base_view_model.dart';
import '../../data/models/youtube_playlist.dart';

class YouTubePlaylistViewModel extends BaseViewModel {
  // Sample channel IDs for testing
  static const List<String> sampleChannelIds = [
    'UC_x5XG1OV2P6uZZ5FSM9Ttw',  // Google Developers
    'UCJowOS1R0FnhipXVqEnYU1A',  // Flutter
    'UCYfdidRxbB8Qhf0Nx7ioOYw',  // Test channel
  ];

  // Sample playlist IDs for testing
  static const List<String> samplePlaylistIds = [
    'PL4cUxeGkcC9gZD-Tvwfod2gaISzfRiP9d',   // Node.js Crash Course by The Net Ninja
    'PLillGF-RfqbYeckUaD1z6nviTp31GLTH8',   // Node.js & Express From Scratch by Traversy Media
    'PLillGF-RfqbZ7s3t6ZInY3NjEOOX7hsBv',   // Flutter Crash Course by Traversy Media
    'PL4cUxeGkcC9jLYyp2Aoh6hcWuxFDX6PBJ',   // Flutter & Firebase App Build by The Net Ninja
    'PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG',   // Flutter Widget of the Week by Flutter
  ];

  final ApiClient _apiClient;
  
  final RxList<YouTubePlaylist> playlists = <YouTubePlaylist>[].obs;
  final Rx<YouTubePlaylist?> selectedPlaylist = Rx<YouTubePlaylist?>(null);
  final RxString nextPageToken = ''.obs;
  final RxString prevPageToken = ''.obs;
  final Rx<PageInfo> pageInfo = PageInfo(totalResults: 0, resultsPerPage: 0).obs;

  YouTubePlaylistViewModel({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  void onInit() {
    super.onInit();
    // Try loading playlists by channel ID instead
    loadPlaylists(channelId: sampleChannelIds[0]);
  }

  Future<void> loadPlaylists({
    String? channelId,
    String? id,
    bool? mine,
  }) async {
    try {
      setLoading(true);
      clearError();

      // Ensure only one parameter is used
      Map<String, String> queryParams = {};
      if (channelId != null) {
        queryParams['channelId'] = channelId;
      } else if (id != null) {
        queryParams['id'] = id;
      } else if (mine != null) {
        queryParams['mine'] = mine.toString();
      }

      developer.log('Loading playlists with params: $queryParams');

      final response = await _apiClient.get(
        '/plat/youtube/playlist/list',
        queryParams: queryParams,
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        developer.log('Playlist list response: $jsonResponse');

        if (jsonResponse['code'] == 0 || jsonResponse['code'] == '0') {
          final data = jsonResponse['data'] ?? {};
          
          // Handle empty data case
          if (data.isEmpty) {
            developer.log('No data returned from API');
            playlists.clear();
            nextPageToken.value = '';
            prevPageToken.value = '';
            pageInfo.value = PageInfo(totalResults: 0, resultsPerPage: 0);
            return;
          }

          // Parse items if they exist
          if (data['items'] != null && data['items'] is List) {
            final items = List<Map<String, dynamic>>.from(data['items']);
            playlists.value = items.map((item) => YouTubePlaylist.fromJson(item)).toList();
            nextPageToken.value = data['nextPageToken'] ?? '';
            prevPageToken.value = data['prevPageToken'] ?? '';
            if (data['pageInfo'] != null) {
              pageInfo.value = PageInfo.fromJson(data['pageInfo']);
            }
            developer.log('Successfully loaded ${playlists.length} playlists');
          } else {
            developer.log('No items found in response data');
            playlists.clear();
          }
        } else {
          final errorMsg = 'Failed to load playlists: ${jsonResponse['msg']}';
          developer.log(errorMsg);
          throw Exception(errorMsg);
        }
      } else {
        final errorMsg = 'Failed to load playlists: ${response.reasonPhrase}';
        developer.log(errorMsg, error: response.statusCode);
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      developer.log('Error loading playlists', error: e, stackTrace: stackTrace);
      handleError(e);
      Get.snackbar(
        'Error',
        'Failed to load playlists',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> loadPlaylistsByIds(List<String> playlistIds) async {
    if (playlistIds.isEmpty) return;
    await loadPlaylists(id: playlistIds.join(','));
  }

  Future<void> updatePlaylist({
    required String id,
    required String title,
    String? description,
  }) async {
    try {
      setLoading(true);
      clearError();

      final requestBody = {
        'id': id,
        'title': title,
        if (description != null) 'description': description,
      };

      developer.log('Updating playlist: ${json.encode(requestBody)}');

      final response = await _apiClient.post(
        '/plat/youtube/playlist/update',
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        developer.log('Update playlist response: ${response.body}');

        if (jsonResponse['code'] == 0 || jsonResponse['code'] == '0') {
          // Update the playlist in the list
          final index = playlists.indexWhere((p) => p.id == id);
          if (index != -1) {
            final updatedPlaylist = YouTubePlaylist(
              id: id,
              title: title,
              description: description ?? playlists[index].description,
              privacyStatus: playlists[index].privacyStatus,
              channelId: playlists[index].channelId,
              itemCount: playlists[index].itemCount,
              thumbnailUrl: playlists[index].thumbnailUrl,
              publishedAt: playlists[index].publishedAt,
            );
            playlists[index] = updatedPlaylist;
          }

          developer.log('Successfully updated playlist: $title');
          Get.snackbar(
            'Success',
            'Playlist updated successfully',
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          final errorMsg = 'Failed to update playlist: ${jsonResponse['msg']}';
          developer.log(errorMsg);
          throw Exception(errorMsg);
        }
      } else {
        final errorMsg = 'Failed to update playlist: ${response.reasonPhrase}';
        developer.log(errorMsg, error: response.statusCode);
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      developer.log('Error updating playlist', error: e, stackTrace: stackTrace);
      handleError(e);
      Get.snackbar(
        'Error',
        'Failed to update playlist',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> deletePlaylist(String id) async {
    try {
      setLoading(true);
      clearError();

      developer.log('Deleting playlist: $id');

      final response = await _apiClient.post(
        '/plat/youtube/playlist/delete',
        body: json.encode({'id': id}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        developer.log('Delete playlist response: ${response.body}');

        if (jsonResponse['code'] == 0 || jsonResponse['code'] == '0') {
          // Remove the playlist from the list
          playlists.removeWhere((p) => p.id == id);
          
          developer.log('Successfully deleted playlist: $id');
          Get.snackbar(
            'Success',
            'Playlist deleted successfully',
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          final errorMsg = 'Failed to delete playlist: ${jsonResponse['msg']}';
          developer.log(errorMsg);
          throw Exception(errorMsg);
        }
      } else {
        final errorMsg = 'Failed to delete playlist: ${response.reasonPhrase}';
        developer.log(errorMsg, error: response.statusCode);
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      developer.log('Error deleting playlist', error: e, stackTrace: stackTrace);
      handleError(e);
      Get.snackbar(
        'Error',
        'Failed to delete playlist',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> createPlaylist({
    required String title,
    required String description,
    required PlaylistPrivacyStatus privacyStatus,
  }) async {
    try {
      setLoading(true);
      clearError();

      final playlist = YouTubePlaylist(
        title: title,
        description: description,
        privacyStatus: privacyStatus,
      );

      developer.log('Creating playlist: ${json.encode(playlist.toJson())}');

      final response = await _apiClient.post(
        '/plat/youtube/playlist/insert',
        body: json.encode(playlist.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        developer.log('Create playlist response: ${response.body}');

        if (jsonResponse['code'] == 0 || jsonResponse['code'] == '0') {
          final newPlaylist = YouTubePlaylist.fromJson(jsonResponse['data']);
          playlists.add(newPlaylist);
          developer.log('Successfully created playlist: ${newPlaylist.title}');
          Get.snackbar(
            'Success',
            'Playlist created successfully',
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          final errorMsg = 'Failed to create playlist: ${jsonResponse['msg']}';
          developer.log(errorMsg);
          throw Exception(errorMsg);
        }
      } else {
        final errorMsg = 'Failed to create playlist: ${response.reasonPhrase}';
        developer.log(errorMsg, error: response.statusCode);
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      developer.log('Error creating playlist', error: e, stackTrace: stackTrace);
      handleError(e);
      Get.snackbar(
        'Error',
        'Failed to create playlist',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setLoading(false);
    }
  }

  void selectPlaylist(YouTubePlaylist playlist) {
    selectedPlaylist.value = playlist;
  }
} 