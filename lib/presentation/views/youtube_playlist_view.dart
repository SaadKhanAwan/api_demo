import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/youtube_playlist.dart';
import '../viewmodels/youtube_playlist_viewmodel.dart';
import 'youtube_playlist_item_view.dart';

class YouTubePlaylistView extends GetView<YouTubePlaylistViewModel> {
  const YouTubePlaylistView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Playlists'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.loadPlaylists(channelId: YouTubePlaylistViewModel.sampleChannelIds[0]),
            tooltip: 'Refresh Playlists',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Error: ${controller.error.value}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    controller.clearError();
                    controller.loadPlaylists(channelId: YouTubePlaylistViewModel.sampleChannelIds[0]);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.playlists.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No playlists found'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.loadPlaylists(channelId: YouTubePlaylistViewModel.sampleChannelIds[0]),
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: () => controller.loadPlaylists(channelId: YouTubePlaylistViewModel.sampleChannelIds[0]),
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: controller.playlists.length,
                itemBuilder: (context, index) {
                  final playlist = controller.playlists[index];
                  return PlaylistItem(playlist: playlist);
                },
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: () => _showCreatePlaylistDialog(context),
                child: const Icon(Icons.add),
                tooltip: 'Create Playlist',
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showCreatePlaylistDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final selectedPrivacy = PlaylistPrivacyStatus.private.obs;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Playlist'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter playlist title',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter playlist description',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Obx(() => DropdownButtonFormField<PlaylistPrivacyStatus>(
                value: selectedPrivacy.value,
                decoration: const InputDecoration(
                  labelText: 'Privacy Status',
                ),
                items: PlaylistPrivacyStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.name.capitalize!),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) selectedPrivacy.value = value;
                },
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Title is required',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }
              if (descriptionController.text.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Description is required',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }

              controller.createPlaylist(
                title: titleController.text,
                description: descriptionController.text,
                privacyStatus: selectedPrivacy.value,
              );
              Get.back();
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class PlaylistItem extends StatelessWidget {
  final YouTubePlaylist playlist;

  const PlaylistItem({
    Key? key,
    required this.playlist,
  }) : super(key: key);

  void _showEditDialog(BuildContext context) {
    final titleController = TextEditingController(text: playlist.title);
    final descriptionController = TextEditingController(text: playlist.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Playlist'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter playlist title',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter playlist description',
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Title is required',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }

              if (playlist.id == null) {
                Get.snackbar(
                  'Error',
                  'Cannot update playlist: ID is missing',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }

              Get.find<YouTubePlaylistViewModel>().updatePlaylist(
                id: playlist.id!,
                title: titleController.text,
                description: descriptionController.text,
              );
              Get.back();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Playlist'),
        content: Text('Are you sure you want to delete "${playlist.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () {
              if (playlist.id == null) {
                Get.snackbar(
                  'Error',
                  'Cannot delete playlist: ID is missing',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }

              Get.find<YouTubePlaylistViewModel>().deletePlaylist(playlist.id!);
              Get.back();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(playlist.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              playlist.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getPrivacyStatusColor(playlist.privacyStatus),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    playlist.privacyStatus.name.capitalize!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
                if (playlist.itemCount != null) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.playlist_play, size: 16, color: Theme.of(context).hintColor),
                  const SizedBox(width: 4),
                  Text(
                    '${playlist.itemCount} videos',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showEditDialog(context),
              tooltip: 'Edit Playlist',
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteConfirmation(context),
              tooltip: 'Delete Playlist',
              color: Colors.red,
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () {
          Get.find<YouTubePlaylistViewModel>().selectPlaylist(playlist);
          Get.to(() => YouTubePlaylistItemView(
            playlistId: playlist.id,
          ));
        },
      ),
    );
  }

  Color _getPrivacyStatusColor(PlaylistPrivacyStatus status) {
    switch (status) {
      case PlaylistPrivacyStatus.public:
        return Colors.green;
      case PlaylistPrivacyStatus.private:
        return Colors.red;
      case PlaylistPrivacyStatus.unlisted:
        return Colors.orange;
    }
  }
} 