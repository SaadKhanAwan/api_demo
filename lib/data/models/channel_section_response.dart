import 'package:api_integration/data/models/channel_section.dart';

class ChannelSectionResponse {
  final String code;
  final String msg;
  final List<ChannelSection> items;

  ChannelSectionResponse({
    required this.code,
    required this.msg,
    required this.items,
  });

  factory ChannelSectionResponse.fromJson(Map<String, dynamic> json) {
    // Extract items from the response data
    List<ChannelSection> extractedItems = [];
    
    if (json['data']?['response']?['data']?['items'] is List) {
      extractedItems = (json['data']['response']['data']['items'] as List)
          .map((item) => ChannelSection.fromJson(item))
          .toList();
    } else if (json['data']?['error'] != null) {
      // Handle error case - throw an exception with the error message
      final error = json['data']['error'];
      throw Exception(error['message'] ?? 'Unknown error occurred');
    }

    return ChannelSectionResponse(
      code: json['code']?.toString() ?? '',
      msg: json['msg']?.toString() ?? '',
      items: extractedItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'msg': msg,
      'data': {
        'items': items.map((item) => item.toJson()).toList(),
      },
    };
  }
} 