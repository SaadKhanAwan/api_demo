import 'package:http/http.dart' as http;

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
} 