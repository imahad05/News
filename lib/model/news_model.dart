import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class NewsModel extends ChangeNotifier {
  List<Article> _articles = [];
  String _category = "General";

  String get category => _category;
  List<Article> get articles => _articles;

  void setCategory(String category) {
  _category = category;
  fetchNews();
}

  Future<void> fetchNews() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://newsapi.org/v2/top-headlines?country=us&category=${_category.toLowerCase()}&apiKey=bf512b8f0830405ea34fd8f4154e363c',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _articles =
            (data['articles'] as List)
                .map((article) => Article.fromJson(article))
                .toList();
      } else {
        _articles = [
          Article(title: "Failed to load news", description: "", imageUrl: ""),
        ];
      }
    } catch (e) {
      _articles = [Article(title: "Error: $e", description: "", imageUrl: "")];
    }
    notifyListeners();
  }
}

class Article {
  final String title;
  final String description;
  final String imageUrl;

  Article({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? "No Title",
      description: json['description'] ?? "No Description",
      imageUrl: json['urlToImage'] ?? "",
    );
  }
}
