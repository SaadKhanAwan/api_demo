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
            controller.loadVideos(
              chart: 'mostPopular',
              id: YouTubeVideoViewModel.sampleVideoIds.join(','),
            );
            controller.loadRatedVideos(
              id: YouTubeVideoViewModel.sampleVideoIds.join(','),
            );
          },
          tooltip: 'Refresh Videos',
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
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  controller.clearError();
                  controller.loadVideos(
                    chart: 'mostPopular',
                    id: YouTubeVideoViewModel.sampleVideoIds.join(','),
                  );
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Load Sample Videos'),
              ),
            ],
          ),
        );
      }

      if (controller.videos.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'No videos found',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => controller.loadVideos(chart: 'mostPopular'),
                    icon: const Icon(Icons.trending_up),
                    label: const Text('Load Popular'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () => controller.loadVideos(
                      id: YouTubeVideoViewModel.sampleVideoIds.join(','),
                    ),
                    icon: const Icon(Icons.video_library),
                    label: const Text('Load Samples'),
                  ),
                ],
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.loadVideos(
          chart: 'mostPopular',
          id: YouTubeVideoViewModel.sampleVideoIds.join(','),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: controller.videos.length,
          itemBuilder: (context, index) {
            final video = controller.videos[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                leading: video.snippet.thumbnails.defaultThumbnail?.url != null
                    ? Image.network(
                        video.snippet.thumbnails.defaultThumbnail!.url,
                        width: 120,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error),
                      )
                    : const Icon(Icons.video_library),
                title: Text(
                  video.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.snippet.channelTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${video.statistics.viewCount} views',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                onTap: () => controller.selectVideo(video),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildRatedVideosList() {
    return Obx(() {
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
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  controller.clearError();
                  controller.loadRatedVideos(
                    id: YouTubeVideoViewModel.sampleVideoIds.join(','),
                  );
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Load Rated Videos'),
              ),
            ],
          ),
        );
      }

      if (controller.ratedVideos.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'No rated videos found',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => controller.loadRatedVideos(
               
                  id: YouTubeVideoViewModel.sampleVideoIds.join(','),
                ),
                icon: const Icon(Icons.thumb_up),
                label: const Text('Load Sample Rated Videos'),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => controller.loadRatedVideos(
          id: YouTubeVideoViewModel.sampleVideoIds.join(','),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: controller.ratedVideos.length,
          itemBuilder: (context, index) {
            final video = controller.ratedVideos[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                leading: video.snippet.thumbnails.defaultThumbnail?.url != null
                    ? Image.network(
                        video.snippet.thumbnails.defaultThumbnail!.url,
                        width: 120,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error),
                      )
                    : const Icon(Icons.video_library),
                title: Text(
                  video.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.snippet.channelTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text(
                          '${video.statistics.viewCount} views',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          video.rating == 'like'
                              ? Icons.thumb_up
                              : Icons.thumb_down,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () => controller.selectVideo(video),
              ),
            );
          },
        ),
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
        title: Text(video.snippet.title),
        subtitle: Text(
          video.snippet.description,
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