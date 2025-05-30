import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/youtube_channel_viewmodel.dart';
import '../../data/models/youtube_channel.dart';
import 'youtube_video_view.dart';
import 'channel_section_view.dart';
import 'video_category_view.dart';

class YouTubeChannelView extends GetView<YouTubeChannelViewModel> {
  const YouTubeChannelView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Channels'),
        actions: [
          IconButton(
            icon: const Icon(Icons.video_library),
            onPressed: () => Get.to(() => const YouTubeVideoView()),
            tooltip: 'Manage Videos',
          ),
          IconButton(
            icon: const Icon(Icons.view_module),
            onPressed: () => Get.to(() => const ChannelSectionView()),
            tooltip: 'Manage Sections',
          ),
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () => Get.to(() => const VideoCategoryView()),
            tooltip: 'Video Categories',
          ),
        ],
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
                const Text('No channels found'),
                ElevatedButton(
                  onPressed: controller.loadChannels,
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.channels.length,
          itemBuilder: (context, index) {
            final channel = controller.channels[index];
            return ChannelListItem(
              channel: channel,
              onTap: () => controller.selectChannel(channel),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.loadChannels,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class ChannelListItem extends StatelessWidget {
  final YouTubeChannel channel;
  final VoidCallback onTap;

  const ChannelListItem({
    Key? key,
    required this.channel,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(channel.channelId),
        subtitle: Text(
          channel.brandingSettings?.channel.description ?? 'No description',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: onTap,
      ),
    );
  }
} 