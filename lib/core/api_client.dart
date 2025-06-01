import 'package:http/http.dart' as http;
import 'dart:io';

class ApiClient {
  static const String baseUrl = 'https://platapi.aitoearn.cn/api';
  final String? authToken;

  ApiClient({this.authToken});

  Map<String, String> get headers {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    if (authToken != null) {
      headers['Authorization'] = authToken!;
    }
    return headers;
  }

  Future<http.Response> get(String endpoint, {Map<String, String>? queryParams}) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);
    return await http.get(uri, headers: headers);
  }

  Future<http.Response> post(String endpoint, {dynamic body}) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    return await http.post(uri, headers: headers, body: body);
  }

  Future<http.Response> uploadFile(String endpoint, {
    required String filePath,
    Map<String, String>? fields,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final request = http.MultipartRequest('POST', uri);
    
    // Add authorization header if available
    if (authToken != null) {
      request.headers['Authorization'] = authToken!;
    }

    // Add the file
    final file = File(filePath);
    final fileStream = http.ByteStream(file.openRead());
    final length = await file.length();
    
    final multipartFile = http.MultipartFile(
      'file',
      fileStream,
      length,
      filename: filePath.split(Platform.pathSeparator).last,
    );
    request.files.add(multipartFile);

    // Add other fields
    if (fields != null) {
      request.fields.addAll(fields);
    }

    // Send the request
    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }
} 