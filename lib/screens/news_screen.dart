import 'package:flutter/material.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/model/theme_model.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NewsScreen extends StatefulWidget {
  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  String drop_down_value = 'General';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Latest News")),
      body: Column(
        children: [
          // Theme Switcher
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Toggle Theme", style: TextStyle(fontSize: 18)),
                Consumer<ThemeModel>(
                  builder: (context, theme, child) {
                    return Switch(
                      value: theme.isDark,
                      onChanged: (value) {
                        Provider.of<ThemeModel>(
                          context,
                          listen: false,
                        ).toggleTheme();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
            child: DropdownButton<String>(
              value: drop_down_value,
              items:
                  ["General", "Sports", "Technology"].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  drop_down_value = value ?? "General";
                });
                Provider.of<NewsModel>(
                  context,
                  listen: false,
                ).setCategory(value!);
              },
            ),
          ),
          // News List with FutureBuilder
          Expanded(
            child: FutureBuilder(
              future:
                  Provider.of<NewsModel>(context, listen: false).fetchNews(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error: ${snapshot.error}",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                } else {
                  return Consumer<NewsModel>(
                    builder: (context, news, child) {
                      return ListView.builder(
                        itemCount: news.articles.length,
                        itemBuilder: (context, index) {
                          final article = news.articles[index];
                          return NewsCard(
                            title: article.title,
                            description: article.description,
                            imageUrl: article.imageUrl,
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
          // Refresh Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Provider.of<NewsModel>(context, listen: false).fetchNews();
              },
              child: Text("Refresh News"),
            ),
          ),
        ],
      ),
    );
  }
}

// News Card Widget
class NewsCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  const NewsCard({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            imageUrl.isNotEmpty
                ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget:
                      (context, url, error) =>
                          Icon(Icons.error, color: Colors.red),
                )
                : Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey,
                  child: Icon(Icons.image_not_supported),
                ),
            SizedBox(width: 12),
            // Title and Description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
