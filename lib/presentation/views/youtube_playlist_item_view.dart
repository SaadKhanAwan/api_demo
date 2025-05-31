import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/youtube_playlist_item.dart';
import '../viewmodels/youtube_playlist_item_viewmodel.dart';

class YouTubePlaylistItemView extends GetView<YouTubePlaylistItemViewModel> {
  final String? playlistId;
  final String? itemId;

  const YouTubePlaylistItemView({
    Key? key,
    this.playlistId,
    this.itemId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Load items when the view is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadPlaylistItems(
        id: itemId,
        playlistId: playlistId,
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Playlist Items'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.loadPlaylistItems(
              id: itemId,
              playlistId: playlistId,
            ),
            tooltip: 'Refresh Items',
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
                    controller.loadPlaylistItems(
                      id: itemId,
                      playlistId: playlistId,
                    );
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.playlistItems.isEmpty) {
          return const Center(
            child: Text('No items found in this playlist'),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadPlaylistItems(
            id: itemId,
            playlistId: playlistId,
          ),
          child: ListView.builder(
            itemCount: controller.playlistItems.length,
            itemBuilder: (context, index) {
              final item = controller.playlistItems[index];
              return PlaylistItemCard(item: item);
            },
          ),
        );
      }),
    );
  }
}

class PlaylistItemCard extends StatelessWidget {
  final YouTubePlaylistItem item;

  const PlaylistItemCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: item.thumbnailUrl != null
            ? Image.network(
                item.thumbnailUrl!,
                width: 120,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.video_library,
                  size: 40,
                ),
              )
            : const Icon(
                Icons.video_library,
                size: 40,
              ),
        title: Text(item.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.description.isNotEmpty) ...[
              Text(
                item.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
            ],
            if (item.channelTitle != null)
              Text(
                item.channelTitle!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            if (item.position != null)
              Text(
                'Position: ${item.position! + 1}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Handle item tap - could navigate to video details or play the video
          if (item.videoId != null) {
            // TODO: Implement video playback or navigation
            Get.snackbar(
              'Video',
              'Opening video ${item.videoId}',
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        },
      ),
    );
  }
} 