import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/youtube_channel_viewmodel.dart';
import '../../data/models/youtube_channel.dart';
import 'youtube_video_view.dart';
import 'channel_section_view.dart';
import 'video_category_view.dart';
import 'youtube_playlist_view.dart';

class YouTubeChannelView extends GetView<YouTubeChannelViewModel> {
  const YouTubeChannelView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Channels'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'YouTube Manager',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Manage your YouTube content',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Channels'),
              selected: true,
              onTap: () {
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_library),
              title: const Text('Videos'),
              onTap: () {
                Get.back();
                Get.to(() => const YouTubeVideoView());
              },
            ),
            ListTile(
              leading: const Icon(Icons.playlist_play),
              title: const Text('Playlists'),
              onTap: () {
                Get.back();
                Get.to(() => const YouTubePlaylistView());
              },
            ),
            ListTile(
              leading: const Icon(Icons.view_module),
              title: const Text('Channel Sections'),
              onTap: () {
                Get.back();
                Get.to(() => const ChannelSectionView());
              },
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Video Categories'),
              onTap: () {
                Get.back();
                Get.to(() => const VideoCategoryView());
              },
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${controller.error.value}',
                  style: const TextStyle(color: Colors.red),
                ),
                ElevatedButton(
                  onPressed: controller.loadChannels,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.channels.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'No channels found',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => controller.loadMyChannels(),
                      icon: const Icon(Icons.account_circle),
                      label: const Text('Load My Channels'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () => controller.loadChannelsByIds(
                        YouTubeChannelViewModel.sampleChannelIds,
                      ),
                      icon: const Icon(Icons.video_library),
                      label: const Text('Load Sample Channels'),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.channels.length,
          itemBuilder: (context, index) {
            final channel = controller.channels[index];
            return ChannelItem(channel: channel);
          },
        );
      }),
    );
  }
}

class ChannelItem extends StatelessWidget {
  final YouTubeChannel channel;

  const ChannelItem({
    Key? key,
    required this.channel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: channel.snippet.thumbnails.defaultThumbnail != null
            ? Image.network(
                channel.snippet.thumbnails.defaultThumbnail!.url,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              )
            : const CircleAvatar(child: Icon(Icons.account_circle)),
        title: Text(channel.snippet.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              channel.snippet.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.people, size: 16, color: Theme.of(context).hintColor),
                const SizedBox(width: 4),
                Text(
                  '${channel.statistics.subscriberCount} subscribers',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
                Icon(Icons.video_library, size: 16, color: Theme.of(context).hintColor),
                const SizedBox(width: 4),
                Text(
                  '${channel.statistics.videoCount} videos',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        onTap: () => Get.find<YouTubeChannelViewModel>().selectChannel(channel),
      ),
    );
  }
} 