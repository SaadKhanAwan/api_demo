import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/bindings.dart';
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
      initialBinding: YouTubeBindings(),
      home: const YouTubeChannelView(),
    );
  }
}
