import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/api_client.dart';
import 'presentation/viewmodels/youtube_channel_viewmodel.dart';
import 'presentation/viewmodels/youtube_video_viewmodel.dart';
import 'presentation/viewmodels/channel_section_viewmodel.dart';
import 'presentation/viewmodels/video_category_viewmodel.dart';
import 'presentation/views/youtube_channel_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'YouTube Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialBinding: BindingsBuilder(() {
        // Initialize API client
        final apiClient = ApiClient(authToken: 'YOUR_AUTH_TOKEN'); // Replace with actual token
        
        // Initialize ViewModels
        Get.put(YouTubeChannelViewModel(apiClient: apiClient));
        Get.put(YouTubeVideoViewModel(apiClient: apiClient));
        Get.put(ChannelSectionViewModel(apiClient: apiClient));
        Get.put(VideoCategoryViewModel(apiClient: apiClient));
      }),
      home: const YouTubeChannelView(),
    );
  }
}
