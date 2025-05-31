import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodels/youtube_video_category_viewmodel.dart';
import '../../data/models/youtube_video_category.dart';

class VideoCategoryView extends GetView<YouTubeVideoCategoryViewModel> {
  const VideoCategoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Categories'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            tooltip: 'Change Region',
            onSelected: (regionCode) {
              controller.loadVideoCategoriesByRegion(regionCode);
            },
            itemBuilder: (context) {
              return YouTubeVideoCategoryViewModel.commonRegionCodes.map((code) {
                return PopupMenuItem<String>(
                  value: code,
                  child: Text('$code - ${_getRegionName(code)}'),
                );
              }).toList();
            },
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
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    controller.clearError();
                    controller.loadVideoCategoriesByIds(
                      YouTubeVideoCategoryViewModel.sampleCategoryIds,
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Load Sample Categories'),
                ),
              ],
            ),
          );
        }

        if (controller.categories.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'No categories found',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => controller.loadUSVideoCategories(),
                      icon: const Icon(Icons.public),
                      label: const Text('Load US Categories'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        controller.loadVideoCategoriesByIds(
                          YouTubeVideoCategoryViewModel.sampleCategoryIds,
                        );
                      },
                      icon: const Icon(Icons.category),
                      label: const Text('Load Samples'),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadUSVideoCategories(),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final category = controller.categories[index];
              return VideoCategoryItem(
                category: category,
                onTap: () => controller.selectCategory(category),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.loadUSVideoCategories(),
        child: const Icon(Icons.refresh),
        tooltip: 'Refresh Categories',
      ),
    );
  }

  String _getRegionName(String code) {
    final regionNames = {
      'US': 'United States',
      'GB': 'United Kingdom',
      'CA': 'Canada',
      'AU': 'Australia',
      'IN': 'India',
    };
    return regionNames[code] ?? code;
  }
}

class VideoCategoryItem extends StatelessWidget {
  final YouTubeVideoCategory category;
  final VoidCallback onTap;

  const VideoCategoryItem({
    Key? key,
    required this.category,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        title: Text(
          category.snippet.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category ID: ${category.id}'),
            if (category.snippet.channelId.isNotEmpty)
              Text('Channel: ${category.snippet.channelId}'),
            Text(
              'Assignable: ${category.snippet.assignable ? 'Yes' : 'No'}',
              style: TextStyle(
                color: category.snippet.assignable ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
} 