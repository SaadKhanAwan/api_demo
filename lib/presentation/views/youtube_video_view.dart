import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/youtube_video.dart';
import '../viewmodels/youtube_video_viewmodel.dart';

class YouTubeVideoView extends GetView<YouTubeVideoViewModel> {
  const YouTubeVideoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('YouTube Videos'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'All Videos'),
              Tab(text: 'Rated Videos'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildVideosList(),
            _buildRatedVideosList(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.loadVideos();
            controller.loadRatedVideos();
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }

  Widget _buildVideosList() {
    return Obx(() {
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
                onPressed: controller.loadVideos,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      if (controller.videos.isEmpty) {
        return const Center(child: Text('No videos found'));
      }

      return ListView.builder(
        itemCount: controller.videos.length,
        itemBuilder: (context, index) {
          final video = controller.videos[index];
          return VideoListItem(
            video: video,
            onDelete: () => controller.deleteVideo(video.id),
            onRate: (rating) => controller.rateVideo(video.id, rating),
          );
        },
      );
    });
  }

  Widget _buildRatedVideosList() {
    return Obx(() {
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
                onPressed: controller.loadRatedVideos,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      if (controller.ratedVideos.isEmpty) {
        return const Center(child: Text('No rated videos found'));
      }

      return ListView.builder(
        itemCount: controller.ratedVideos.length,
        itemBuilder: (context, index) {
          final video = controller.ratedVideos[index];
          return VideoListItem(
            video: video,
            onDelete: () => controller.deleteVideo(video.id),
            onRate: (rating) => controller.rateVideo(video.id, rating),
          );
        },
      );
    });
  }
}

class VideoListItem extends StatelessWidget {
  final YouTubeVideo video;
  final VoidCallback onDelete;
  final Function(VideoRating) onRate;

  const VideoListItem({
    Key? key,
    required this.video,
    required this.onDelete,
    required this.onRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(video.title ?? 'Untitled Video'),
        subtitle: Text(
          video.description ?? 'No description',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.thumb_up),
              onPressed: () => onRate(VideoRating.like),
              color: video.rating == 'like' ? Colors.blue : null,
            ),
            IconButton(
              icon: const Icon(Icons.thumb_down),
              onPressed: () => onRate(VideoRating.dislike),
              color: video.rating == 'dislike' ? Colors.blue : null,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
} 