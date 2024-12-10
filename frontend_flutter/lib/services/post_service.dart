import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<dynamic>> fetchPosts() async {
  final response =
      await http.get(Uri.parse('http://192.168.1.25:8000/api/posts/'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load posts');
  }
}

Future<void> createPost(String title, String content) async {
  final response = await http.post(
    Uri.parse('http://192.168.1.25:8000/api/posts/'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'title': title, 'content': content}),
  );

  if (response.statusCode != 201) {
    throw Exception('Failed to create post');
  }
}
