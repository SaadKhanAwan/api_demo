import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/channel_section.dart';
import '../viewmodels/channel_section_viewmodel.dart';

class ChannelSectionView extends GetView<ChannelSectionViewModel> {
  const ChannelSectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Channel Sections'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
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
                  onPressed: controller.loadSections,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.sections.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No sections found'),
                ElevatedButton(
                  onPressed: () => _showAddEditDialog(context),
                  child: const Text('Add Section'),
                ),
              ],
            ),
          );
        }

        return Stack(
          children: [
            ListView.builder(
              itemCount: controller.sections.length,
              itemBuilder: (context, index) {
                final section = controller.sections[index];
                return ChannelSectionItem(
                  section: section,
                  onEdit: () => _showAddEditDialog(context, section),
                  onDelete: () => _showDeleteDialog(context, section),
                );
              },
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: () => _showAddEditDialog(context),
                child: const Icon(Icons.add),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showDeleteDialog(BuildContext context, ChannelSection section) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Section'),
        content: Text('Are you sure you want to delete "${section.snippet.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              if (section.id != null) {
                controller.deleteSection(section.id!);
              }
            },
            child: const Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  void _showAddEditDialog(BuildContext context, [ChannelSection? section]) {
    final isEditing = section != null;
    final titleController = TextEditingController(
      text: isEditing ? section.snippet.title : '',
    );
    final positionController = TextEditingController(
      text: isEditing ? section.snippet.position.toString() : '0',
    );
    final selectedType = (isEditing ? section.snippet.type : ChannelSectionType.singlePlaylist).obs;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${isEditing ? 'Edit' : 'Add'} Section'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: positionController,
                decoration: const InputDecoration(labelText: 'Position'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Obx(() => DropdownButtonFormField<ChannelSectionType>(
                value: selectedType.value,
                decoration: const InputDecoration(labelText: 'Type'),
                items: ChannelSectionType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.name),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) selectedType.value = value;
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
              final newSection = ChannelSection(
                id: section?.id,
                snippet: ChannelSectionSnippet(
                  type: selectedType.value,
                  title: titleController.text,
                  position: int.tryParse(positionController.text) ?? 0,
                ),
                contentDetails: ChannelSectionContentDetails(
                  playlists: section?.contentDetails.playlists ?? [],
                  channels: section?.contentDetails.channels ?? [],
                ),
              );

              Get.back();
              if (isEditing) {
                controller.updateSection(newSection);
              } else {
                controller.insertSection(newSection);
              }
            },
            child: Text(isEditing ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }
}

class ChannelSectionItem extends StatelessWidget {
  final ChannelSection section;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ChannelSectionItem({
    Key? key,
    required this.section,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(section.snippet.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${section.snippet.type.name}'),
            Text('Position: ${section.snippet.position}'),
            if (section.contentDetails.playlists.isNotEmpty)
              Text('Playlists: ${section.contentDetails.playlists.length}'),
            if (section.contentDetails.channels.isNotEmpty)
              Text('Channels: ${section.contentDetails.channels.length}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
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