import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/video_category.dart';
import '../viewmodels/video_category_viewmodel.dart';

class VideoCategoryView extends GetView<VideoCategoryViewModel> {
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
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => _showRegionCodeDialog(context),
            tooltip: 'Change Region',
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
                  onPressed: controller.loadCategories,
                  child: const Text('Retry'),
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
                Text('No categories found for region: ${controller.selectedRegionCode.value}'),
                ElevatedButton(
                  onPressed: () => _showRegionCodeDialog(context),
                  child: const Text('Change Region'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Region: ${controller.selectedRegionCode.value}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  final category = controller.categories[index];
                  return VideoCategoryItem(
                    category: category,
                    onTap: () => controller.selectCategory(category),
                  );
                },
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.loadCategories,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void _showRegionCodeDialog(BuildContext context) {
    final textController = TextEditingController(
      text: controller.selectedRegionCode.value,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Region'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                labelText: 'Region Code',
                hintText: 'Enter 2-letter region code (e.g., US, GB)',
              ),
              maxLength: 2,
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter a valid 2-letter country code (ISO 3166-1 alpha-2)',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newRegionCode = textController.text.toUpperCase();
              if (newRegionCode.length == 2) {
                Get.back();
                controller.setRegionCode(newRegionCode);
              }
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }
}

class VideoCategoryItem extends StatelessWidget {
  final VideoCategory category;
  final VoidCallback onTap;

  const VideoCategoryItem({
    Key? key,
    required this.category,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(category.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${category.id}'),
            Text('Channel ID: ${category.channelId}'),
            Text('Assignable: ${category.assignable ? 'Yes' : 'No'}'),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
} 